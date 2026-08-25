# Instructions for AI Agents

## Overview

This is a pure Ruby implementation of a AMQP 0-9-1 protocol parser
(more specifically% serialization, deserialization, framing) used by
[Bunny](https://github.com/ruby-amqp/bunny), a Ruby AMQP 0-9-1 client for RabbitMQ.

## Target Ruby Version

This library targets Ruby 3.0 and later versions.

## Comments

 * Only add very important comments, both in tests and in the implementation

## Change Log

If asked to perform change log updates, consult and modify `ChangeLog.md` and stick to its
existing writing style.


## Releases

Releases are published by `.github/workflows/release.yml`, which reacts to a
pushed `v*` tag and pushes the gem to RubyGems.org using
[trusted publishing](https://guides.rubygems.org/trusted-publishing/), so no
RubyGems credentials are needed locally. The workflow refuses to publish unless
the tag is `v` plus `AMQ::Protocol::VERSION`.

### How to Roll (Produce) a New Release

Suppose the current development version in `ChangeLog.md` has
a `## Changes between X.Y.0 and X.(Y+1).0 (unreleased)` section at the top.

To produce a new release:

 1. Update `ChangeLog.md`: replace `(unreleased)` with today's date, e.g. `(Mar 30, 2026)`. Make sure all notable changes since the previous release are listed
 2. Update the version in `lib/amq/protocol/version.rb` to match
 3. Commit with the message `X.(Y+1).0` (just the version number, nothing else)
 4. Tag the commit: `git tag vX.(Y+1).0`
 5. Bump the dev version: add a new `## Changes between X.(Y+1).0 and X.(Y+2).0 (unreleased)` section to `ChangeLog.md` with `No changes yet.` underneath, and update `lib/amq/protocol/version.rb` to the next dev version
 6. Commit with the message `Bump dev version`
 7. Push: `git push && git push origin vX.(Y+1).0`
 8. Watch the release: `gh run watch --workflow=release.yml`


## Git Instructions

 * Never add yourself to the list of commit co-authors

## Style Guide

 * Never add full stops to Markdown list items
