#!/bin/bash
# 
# cman.sh
# Written by Martin Grønholdt              
# December 19, 2011                   
#                                                
# Compress man pages with bzip2.
#
# Version 0.91 December 22, 2011:
# Added file size display, when compressing
#å
# Version 0.9 December 19, 2011:
# Working version. Need to weed out the weaklings, and comment.
VERSION="0.91"

# Name of the script
MY_NAME=`basename $0`

#Directories with man pages
MAN_DIR=""
#Verosity level
VERBOSE_LVL=0

#Print help
function help ()
{
	if [ -n "$1" ]; then
		echo "Unknown option : $1"
	fi
	( echo "Usage: ${MY_NAME} [dirs]" && \
 	cat << EOT
	dirs          A list of space-separated _absolute_ pathnames to the
                  man directories.

EOT
) | less
}

#Process files and directories under the one given as parameter
function process_dir ()
{
	echo "Entering '$1'"	
	for ENTRY in $1/*; do
		#New file name
		FILE=${ENTRY}.bz2
		
		if [ -d ${ENTRY} ]; then #Check for directory
			process_dir ${ENTRY}
		elif [ "`expr ${ENTRY} : '.*\(bz2\)'`" == "bz2" ]; then	#If extension is bz2, the file is probably compressed
			if [ $VERBOSE_LVL -ge 1 ]; then
				echo "File '${ENTRY}' seems to be compressed"
			fi
		elif [ -h ${ENTRY} ]; then #Check for symlink
        	LINK=`readlink ${ENTRY}`.bz2
			rm -f "${ENTRY}" && ln -s "${LINK}" "${FILE}"
 			echo "Link: ${ENTRY} > ${FILE}"
 		elif [ -f ${ENTRY} ]; then #Check for file
			#Get original size
			ORG_SIZE=$(wc -c < "${ENTRY}")
			bzip2 -f9 "${ENTRY}" && chmod 644 "${FILE}"
			COMP_SIZE=$(wc -c < "${FILE}")
			echo "File: ${ENTRY} (${ORG_SIZE}) > ${FILE} (${COMP_SIZE})"
		fi
	done
}

echo "$MY_NAME version ${VERSION}"

#Parse command line
while [ -n "$1" ]; do
	case $1 in
		--verbose|-v)
      		let VERBOSE_LVL++
      		shift
      		;;
    	--help|-h)
      		help
      		exit 0
      		;;
    	/*)
      		MAN_DIR="${MAN_DIR} ${1}"
      		shift
      		;;
    	-*)
      		help $1
      		exit 1
      		;;
		*)
      		echo "\"$1\" is not an absolute path name"
      		exit 1
      		;;
 	esac
done
#No directories to work on?
if [ -z "$MAN_DIR" ]; then
	echo "No directory specified."
	exit 1
fi

# Check that the specified directories actually exist and are readable
for DIR in $MAN_DIR; do
	if [ ! -d "${DIR}" -o ! -r "${DIR}" ]; then
		echo "Directory '${DIR}' does not exist or is not readable"
		exit 1
	fi
done

#Go go!
for DIR in $MAN_DIR; do
	process_dir $DIR
done

echo "Done."