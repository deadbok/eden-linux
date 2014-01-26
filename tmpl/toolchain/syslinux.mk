#mtl
${local_namespace("toolchain.syslinux")}

#${package("$(TOOLCHAIN_BUILD_DIR)/syslinux-$(TOOLCHAIN_SYSLINUX_VERSION)", "", "4.02", "syslinux-$(TOOLCHAIN_SYSLINUX_VERSION).tar.bz2", "http://linux-kernel.uio.no/pub/linux/utils/boot/syslinux/4.xx/$(TOOLCHAIN_SYSLINUX_FILE)")}
${Package("$(TOOLCHAIN_BUILD_DIR)/syslinux-$(TOOLCHAIN_SYSLINUX_VERSION)", "", "4.02", "http://launchpad.net/syslinux/main/$(TOOLCHAIN_SYSLINUX_VERSION)/+download/syslinux-$(TOOLCHAIN_SYSLINUX_VERSION).tar.gz", "$(TOOLCHAIN_BUILD_DIR)/extlinux/extlinux")}
#${syslinux}
#${download()}

#${unpack("$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_SYSLINUX_SRC_DIR)/Makefile")}

${DownloadRule("$(TOOLCHAIN_SYSLINUX_URL)")}

${UnpackRule("$(DOWNLOAD_DIR)/$(TOOLCHAIN_SYSLINUX_FILE)", "$(TOOLCHAIN_BUILD_DIR)", "$(TOOLCHAIN_SYSLINUX_SRC_DIR)/Makefile")}

include toolchain/nasm.mk

#${make('$(TOOLCHAIN_ENV)', "CROSS_COMPILE=$(ARCH_TARGET)-", "installer", "$(TOOLCHAIN_BUILD_DIR)/extlinux/extlinux", "$(TOOLCHAIN_NASM_INSTALL) $(TOOLCHAIN_SYSLINUX_UNPACK)")}

${MakeRule('$(TOOLCHAIN_ENV)', 'CROSS_COMPILE=$(ARCH_TARGET)-', "$(TOOLCHAIN_SYSLINUX_BUILD_DIR)", "installer", "$(TOOLCHAIN_BUILD_DIR)/extlinux/extlinux", "$(TOOLCHAIN_NASM_INSTALL) $(TOOLCHAIN_SYSLINUX_UNPACK)", "TOOLCHAIN_SYSLINUX_INSTALL")}

$(TOOLCHAIN_SYSLINUX_SRC_DIR)/core/isolinux.bin: $(TOOLCHAIN_SYSLINUX_UNPACK)

#toolchain:
#	syslinux:
#		dir = syslinux-${version}
#		group = toolchain
#		version = 4.02
#		url = http://www.kernel.org/pub/linux/utils/boot/syslinux/4.xx/syslinux-${version}.tar.bz2
#		
#		download()
#		unpack(${build_dir.toolchain}/${dir}/Makefile)
#		build(${build_dir.toolchain}/${dir}/extlinux/extlinux, ${unpack} ${install.nasm.toolchain})
#		{
#			${target}: ${dependencies}
#				$env_packages $make -C ${current_package_dir} CROSS_COMPILE=$(ARCH_TARGET)- installer
#		}
#		clean()
#		distclean()
#	:syslinux
#:toolchain

.NOTPARALLEL: