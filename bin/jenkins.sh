#!/bin/bash

echo -e "\n\n==== Setup ===="
source /etc/profile
git fetch && git reset origin/master --hard

echo -e "\n\n==== Ruby 1.9.2 Head ===="
rvm 1.9.2-head@ruby-amqp exec bundle install --local; echo
rvm 1.9.2-head@ruby-amqp exec bundle exec rspec spec
return_status=$?

echo -e "\n\n==== Ruby 1.8.7 ===="
rvm 1.8.7@ruby-amqp exec bundle install --local; echo
rvm 1.8.7@ruby-amqp exec bundle exec rspec spec
return_status=$(expr $return_status + $?)

test $return_status -eq 0
