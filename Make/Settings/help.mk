#!/usr/bin/make
#Varsion Settings/help.mk:default  6.2 28.04.2022
#----------------------  help   --------------------------
.DEFAULT_GOAL := help-default
ifeq ($(OS),Windows_NT)
#----------------------  Windows --------------------------
help-default:
	@printf "Default:\n"
	@for f in $(MAKEFILE_LIST); do  grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $$f | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "	\033[36m%-30s\033[0m %s\n", $$1, $$2}'; done
	@printf "Windows:\n"
	@for f in $(MAKEFILE_LIST); do  grep -E '^[a-zA-Z0-9_-]+:.*?Windows: .*$$' $$f | sort | awk 'BEGIN {FS = ":.*?Windows: "}; {printf "	\033[36m%-30s\033[0m %s\n", $$1, $$2}'; done
help:
	@$(MAKE) help-default
else
#----------------------  Linux --------------------------
help: #Help: Show help text
	@printf "\033[33m##:\033[0m\n"
	@awk 'BEGIN {FS = ":.*?## "} /^[.%a-zA-Z_-]+:.*?## / {printf "   \033[31m make \033[36m%-25s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
help-default:
	@$(MAKE) help-auto
help.%: #Help: help.-% (Help | Linux | Test | Dev | Settings)
	@printf "\033[33m$*:\033[0m\n"
	@for fileX in $(MAKEFILE_LIST); do \
		grep -E '^[.%a-zA-Z_-]+:.*?$*: .*$$' $$fileX | \
		awk 'BEGIN {FS = ":.*?$*: "}; {printf "   \033[31m make \033[36m%-25s\033[0m %s\n", $$1, $$2}'; \
	done
endif

#Varsion Settings/help.mk:auto 1.0 29.04.2022
#----------------------  Авто запуск help   --------------------------
help-auto:
	@echo Auto-Help для просмотра выводимых вайл выполните make help.Help
	@ for fileX in $(MAKEFILE_LIST); do \
		 grep -E '^[a-zA-Z_-]+:.*?Help: .*$$' $$fileX  \
		 | awk 'BEGIN {FS = ":.*?Help: "};{ print $$1}'  \
		 | xargs -r $(MAKE) \
		 ; \
	done
help-auto-test:
	@ for fileX in $(MAKEFILE_LIST); do \
		 grep -E '^[a-zA-Z_-]+:.*?Help: .*$$' $$fileX  \
		 | awk 'BEGIN {FS = ":.*?Help: "};{ print $$1}'  \
		 | xargs -r echo \
		 ; \
	done