#!/usr/bin/make
#Varsion Settings/versions 1.0 28.04.2022
#----------------------  versions   --------------------------
versions: #Settings: Version Packages Makefile
	@for f in $(MAKEFILE_LIST); do  grep -E '^#Varsion .*$$' $$f| awk 'BEGIN {FS = " "}; {printf "	\033[36m%-30s\033[0m 🔖 v%s\n", $$2, $$3}'; done