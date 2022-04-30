#!/usr/bin/make
#Varsion Settings/dir 1.0 28.04.2022
#--------------------------------  DIR   ----------------------------------
ifeq ($(OS),Windows_NT)
#   Windows
	ROOT_DIR := $(shell powershell '(Get-Location).path')
	ROOT_DIR_NAME := $(shell powershell '(Get-Item -Path "'$(ROOT_DIR)'").BaseName')
else
#   Linux
	ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
	# TODO: Исправить.	ROOT_DIR_NAME
	# ROOT_DIR_NAME := $(shell filename $(realpath $(firstword $(MAKEFILE_LIST))))
endif
#--------------------------------------------------------------------------------
root-dir: #Settings: Директория файла Makefile
	@echo "📁 ROOT_DIR= $(ROOT_DIR)"
root-filename: #Settings: Имя файла Makefile
	@echo "📁 ROOT_DIR_NAME= $(ROOT_DIR_NAME)"