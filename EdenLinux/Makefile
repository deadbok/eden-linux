-include build/global.mk
-include build/directories.mk
-include build/target/*.mk
-include build/packages/*.mk
-include build/build.mk

#This is only the first target if the above files whre not found
ifndef BUILD_DIR
all:
ifdef DEBUG
	python distbuild/distbuild.py -l0 conf
else
	python distbuild/distbuild.py conf
endif
	$(MAKE) all
endif