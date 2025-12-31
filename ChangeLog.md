## Changes between 2.4.0 and 2.5.0 (in development)

### Additional Consumer Hot Path Optimizations

Further decode method optimizations for consumer delivery paths:

 * `Basic::Deliver.decode`: uses `getbyte` and `unpack1` for faster field extraction
 * `Basic::ConsumeOk.decode`: simplified using `getbyte` and `byteslice`
 * `Basic::Ack.decode`: uses `unpack1` and `getbyte` for compact decoding
 * `Basic::Nack.decode`: uses `unpack1` and `getbyte` for compact decoding
 * `Basic.decode_properties`: uses `getbyte` for shortstr lengths and `unpack1` throughout

## Changes between 2.3.4 and 2.4.0 (Dec 30, 2025)

### Performance Improvements

Optimized encoding and decoding hot paths:

 * Built-in `Q>`/`q>` packing/unpacking directives are 6-7x faster than the original implementation (that originally targeted Ruby 1.8.x)
 * Switched to `unpack1` instead of `unpack().first` throughout
 * Use `byteslice` instead of `slice` for binary string operations
 * Use `getbyte` for single byte access (4x faster than alternatives)
 * Adopted `frozen_string_literal` pragma

The improvements on Ruby 3.4 are very meaningful:

 * `AMQ::Pack.pack_uint64_big_endian`: about 6.6x faster
 * `AMQ::Pack.unpack_uint64_big_endian`: about 7.2x faster
 * `Basic.Deliver.decode`: about 1.7x faster
 * `Basic.Ack/Nack/Reject.encode`: about 2.5x faster


## Changes between 2.3.3 and 2.3.4 (May 12, 2025)

### (Forward) Compatibility with Ruby 3.5

Contributed by @Earlopain.

GitHub issue: [#80](https://github.com/ruby-amqp/amq-protocol/pull/80)


## Changes between 2.3.2 and 2.3.3 (February 17, 2025)

### Improved Compatibility with Ruby 3.4

Contributed by @BenTalagan.

GitHub issue: [#79](https://github.com/ruby-amqp/amq-protocol/pull/79)

### Support Binary-Encoded Frozen Strings for Payloads

Contributed by @djrodgerspryor.

GitHub issue: [#78](https://github.com/ruby-amqp/amq-protocol/pull/78)


## Changes between 2.3.1 and 2.3.2 (July 10th, 2020)

### Safer Encoding Handling When Serialising Message Properties and Headers

Contributed by @bbascarevic-tti.

GitHub issue: [ruby-amqp/amq-protocol#76](https://github.com/ruby-amqp/amq-protocol/issues/76)


## Changes between 2.3.0 and 2.3.1 (April 8th, 2020)

### Support for connection.update-secret

Used together with the `rabbitmq-auth-backend-oauth2` plugin.

### Squashed a gemspec Warning

GitHub issue: [ruby-amqp/amq-protocol#75](https://github.com/ruby-amqp/amq-protocol/issues/75).



## Changes between 2.2.0 and 2.3.0 (Jan 8th, 2018)

### Support for Additional URI Query Parameters

GitHub issue: [#67](https://github.com/ruby-amqp/amq-protocol/issues/67), [#68](https://github.com/ruby-amqp/amq-protocol/issues/68), [#69](https://github.com/ruby-amqp/amq-protocol/issues/69).

Contributed by Andrew Babichev.




## Changes between 2.1.0 and 2.2.0 (May 11th, 2017)

### Timestamps are Encoded as 64-bit Unsigned Integers

This is a potentially **breaking change**. It is recommended that
all applications that use this gem and pass date/time values in message
properties or headers are upgraded at the same time.

GitHub issue: [#64](https://github.com/ruby-amqp/amq-protocol/issues/64).

Contributed by Carl Hoerberg.



## Changes between 2.0.0 and 2.1.0 (January 28th, 2017)

### Ruby Warnings Squashed

Contributed by Akira Matsuda.

GitHub issue: [#62](https://github.com/ruby-amqp/amq-protocol/pull/62)

### Byte Array Decoding

Byte array values in types now can be
decoded (to the extent Ruby type system
permits) by this library.

GitHub issue: [#58](https://github.com/ruby-amqp/amq-protocol/issues/58)



## Changes between 1.9.x and 2.0.0

2.0.0 has **breaking changes** in header encoding.

### Signed Integer Encoding in Headers

Integer values in headers are now encoded as signed 64-bit
(was unsigned 32-bit previously, unintentionally).

This is a breaking change: consuming messages with integers in headers
published with older versions of this library will break!

### Signed 16 Bit Integer Decoding

Signed 16 bit integers are now decoded correctly.

### Signed 8 Bit Integer Decoding

Signed 8 bit integers are now decoded correctly.

Contributed by Benjamin Conlan.



## Changes between 1.8.0 and 1.9.0

### Performance Improvements in AMQ::BitSet

`AMQ::BitSet#next_clear_bit` is now drastically more efficient
(down from 6 minutes for 10,000 iterations to 4 seconds for 65,536 iterations).

Contributed by Doug Rohrer, Dave Anderson, and Jason Voegele from
[Neo](http://www.neo.com).


## Changes between 1.7.0 and 1.8.0

### Body Framing Fix

Messages exactly 128 Kb in size are now framed correctly.

Contributed by Nicolas Viennot.


## Changes between 1.6.0 and 1.7.0

### connection.blocked Support

`connection.blocked` AMQP 0.9.1 extension is now supported
(should be available as of RabbitMQ 3.2).


## Changes between 1.0.0 and 1.1.0

### Performance Enhancements

Encoding of large payloads is now done more efficiently.

Contributed by Greg Brockman.


## Changes between 1.0.0.pre6 and 1.0.0.pre7

### AMQ::Settings

`AMQ::Settings` extracts settings merging logic and AMQP/AMQPS URI parsing from `amq-client`.
Parsing follows the same convention amqp gem and RabbitMQ Java client follow.

Examples:

``` ruby
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com")            # => vhost is nil, so default (/) will be used
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/")           # => vhost is an empty string
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/%2Fvault")   # => vhost is /vault
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/production") # => vhost is production
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/a.b.c")      # => vhost is a.b.c
AMQ::Settings.parse_amqp_url("amqp://dev.rabbitmq.com/foo/bar")    # => ArgumentError
```


### AMQ::Protocol::TLS_PORT

`AMQ::Protocol::TLS_PORT` is a new constant that contains default AMQPS 0.9.1 port,
5671.
