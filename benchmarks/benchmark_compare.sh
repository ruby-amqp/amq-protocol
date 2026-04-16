#!/usr/bin/env bash
# Benchmarks two commits and prints a before/after delta summary.
#
# Usage:
#   bash benchmarks/benchmark_compare.sh <before-sha> [after-sha] [ruby-binary ...]
#
# Defaults: after-sha = HEAD, ruby-binary = ruby
#
# Examples:
#   bash benchmarks/benchmark_compare.sh 6d857de
#   bash benchmarks/benchmark_compare.sh 6d857de HEAD
#   bash benchmarks/benchmark_compare.sh 6d857de HEAD ruby3.3 ruby3.4
#
# With asdf:
#   bash benchmarks/benchmark_compare.sh 6d857de HEAD \
#     $(asdf where ruby 3.3.11)/bin/ruby \
#     $(asdf where ruby 3.4.9)/bin/ruby
#
# With rbenv:
#   bash benchmarks/benchmark_compare.sh 6d857de HEAD \
#     $(rbenv prefix 3.3.11)/bin/ruby \
#     $(rbenv prefix 3.4.9)/bin/ruby
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <before-sha> [after-sha] [ruby-binary ...]"
  exit 1
fi

DIR="$(cd "$(dirname "$0")" && pwd)"
REPO="$(cd "$DIR/.." && pwd)"

# Resolve to full SHAs immediately, before any git checkout changes HEAD
BEFORE_LABEL=${1}
AFTER_LABEL=${2:-HEAD}
BEFORE=$(git -C "$REPO" rev-parse "$BEFORE_LABEL")
AFTER=$(git -C "$REPO" rev-parse "$AFTER_LABEL")
shift 2 2>/dev/null || shift $#
RUBIES=("${@:-ruby}")
RESULTS="$DIR/results"
mkdir -p "$RESULTS"

CURRENT_BRANCH=$(git -C "$REPO" rev-parse --abbrev-ref HEAD)

restore() {
  git -C "$REPO" checkout --quiet "$CURRENT_BRANCH"
}
trap restore EXIT

run_suite() {
  local label=$1 sha=$2 ruby_bin=$3
  local ruby_label
  ruby_label=$("$ruby_bin" -e 'print "#{RUBY_VERSION}"')
  local tag="${label}_${ruby_label//./_}"
  local out="$RESULTS/${tag}.txt"

  echo
  echo "=== [$ruby_label] $label ($sha) ==="
  git -C "$REPO" checkout --quiet "$sha"
  "$ruby_bin" -e 'require "benchmark/ips"' 2>/dev/null || \
    "$ruby_bin" -S gem install benchmark-ips --quiet --no-document
  # Prepend ruby's own directory to PATH so that bare `ruby` calls in older
  # versions of run_all.rb (before the RbConfig.ruby fix) also use the right binary
  PATH="$(dirname "$ruby_bin"):$PATH" "$ruby_bin" "$DIR/run_all.rb" 2>&1 | tee "$out"
  echo ">>> Saved: $out"
}

for ruby_bin in "${RUBIES[@]}"; do
  run_suite "before" "$BEFORE" "$ruby_bin"
  run_suite "after"  "$AFTER"  "$ruby_bin"
done

# Restore before printing the summary so compare_results.rb is available
restore

echo
echo "=================================================================="
echo "Summary: before ($BEFORE_LABEL) vs after ($AFTER_LABEL)"
echo "=================================================================="

for ruby_bin in "${RUBIES[@]}"; do
  ruby_label=$("$ruby_bin" -e 'print "#{RUBY_VERSION}"')
  before_file="$RESULTS/before_${ruby_label//./_}.txt"
  after_file="$RESULTS/after_${ruby_label//./_}.txt"
  [[ -f "$before_file" && -f "$after_file" ]] || continue

  echo
  echo "  Ruby $ruby_label ($BEFORE_LABEL vs $AFTER_LABEL)"
  "$ruby_bin" "$DIR/compare_results.rb" "$before_file" "$after_file"
done
