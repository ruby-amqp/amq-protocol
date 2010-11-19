#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os, sys

sys.path.append(os.path.join("vendor", "rabbitmq-codegen"))

from amqp_codegen import *
try:
    from jinja2 import Template
except ImportError:
    print "Jinja2 isn't installed. Run easy_install Jinja2 or pip install Jinja2."
    sys.exit(1)

# helpers
def render(path, **context):
    file = open(path)
    template = Template(file.read())
    return template.render(**context)

def main(json_spec_path):
    classes = # TODO
    print render("protocol.rb.pytemplate", classes = classes)

if __name__ == "__main__":
    do_main_dict({"spec": main})
