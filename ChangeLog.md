## Changes between 2.1.0 and 2.2.0 (unreleased)

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
