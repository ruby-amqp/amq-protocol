# Benchmarking

## Running the suite

```bash
ruby benchmarks/run_all.rb
```

Results are saved to `benchmarks/results/` with a timestamp.

## Comparing two commits

`benchmark_compare.sh` runs the full suite on both commits and prints a colour-coded delta summary. The after-sha defaults to `HEAD`.

```bash
bash benchmarks/benchmark_compare.sh <before-sha> [after-sha] [ruby-binary ...]
```

With the current ruby only:
```bash
bash benchmarks/benchmark_compare.sh 6d857de
```

With multiple rubies (asdf example):
```bash
bash benchmarks/benchmark_compare.sh 6d857de HEAD \
  $(asdf where ruby 3.3.11)/bin/ruby \
  $(asdf where ruby 3.4.9)/bin/ruby \
  $(asdf where ruby 4.0.2)/bin/ruby
```

With rbenv:
```bash
bash benchmarks/benchmark_compare.sh 6d857de HEAD \
  $(rbenv prefix 3.3.11)/bin/ruby \
  $(rbenv prefix 3.4.9)/bin/ruby
```

You can also diff any two saved result files directly:
```bash
ruby benchmarks/compare_results.rb benchmarks/results/before_3_4_9.txt benchmarks/results/after_3_4_9.txt
```

## Getting reliable results

Benchmark results are sensitive to system load. For trustworthy numbers:

- Run on an otherwise idle machine (close browsers, pause background processes)
- Results within ±5% of each other between runs are noise — `compare_results.rb` filters these out automatically
- If a benchmark shows a large error margin (e.g. `±10%` in the raw output), discard that result and re-run

## Individual benchmarks

| Script | What it covers |
|---|---|
| `benchmarks/frame_encoding.rb` | Frame encode/decode — the core hot path |
| `benchmarks/table_encoding.rb` | AMQP table encode/decode |
| `benchmarks/method_encoding.rb` | Method/properties encode/decode, Basic.Publish |
| `benchmarks/pack_unpack.rb` | Low-level pack/unpack primitives |

Run any of them directly with `ruby benchmarks/<name>.rb`.
