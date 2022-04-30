#!/usr/bin/make
args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`