#mtl
${local_namespace("target.image")}

${local}SIZE = 256
${local}FILENAME = root.img

$(TARGET_IMAGE_FILE) := $(IMAGES_DIR)/$(TARGET_IMAGE_FILENAME)
$(TARGET_IMAGE_FILE):
	$(DD) if=/dev/zero of=$(TARGET_IMAGE_FILE) bs=1M count=$(TARGET_IMAGE_SIZE)

#target:
#	image:
#		dir = images
#		filename = root.img
#		size = 256
#		
#		mkdir(${root}/${distbuild_dir}/${dir})
#		{
#			${target}: ${target}/.dir
#			
#				
#			${target}/.dir:
#				$mkdir ${target}
#				$touch ${target}/.dir		
#		}
#		file(${root}/${distbuild_dir}/${dir}/${filename}, ${root}/${distbuild_dir}/${dir}/.dir)
#		{
#			${target}: ${dependencies}
#				dd if=/dev/zero of=${target} bs=1M count=${size}
#		}
#	:image
#:target
