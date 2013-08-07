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
