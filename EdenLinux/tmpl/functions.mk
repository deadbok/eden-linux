#mtl

#From: John Graham-Cumming
#	   http://blog.jgc.org/2011/07/gnu-make-recursive-wildcard-function.html
#Recursivly finds all files in a directory and all subdirectories
rwildcard=$(shell echo "Colecting files $1; $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d)))
