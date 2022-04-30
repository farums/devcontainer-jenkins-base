#!/usr/bin/make
#----------------------  Отключить вывод директории   --------------------------
ifndef VERBOSE
MAKEFLAGS += --no-print-directory
endif
