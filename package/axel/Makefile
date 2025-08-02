#
# Copyright (C) 2010-2011 OpenWrt.org
# Copyright (C) 2010 Gianluigi Tiesi <sherpya@netfarm.it>
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=axel
PKG_VERSION:=2.17.14
PKG_RELEASE:=1

# 关键1: 声明为架构无关包
PKG_ARCH:=all

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/axel-download-accelerator/axel/releases/download/v$(PKG_VERSION)/
PKG_HASH:=575f73f640ee836a95d27b54aeed216c45bc1e914cad92da6f00b907d1c94925

PKG_MAINTAINER:=Gianluigi Tiesi <sherpya@netfarm.it>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

# 关键2: 禁用安装标记（对于脚本或架构无关二进制）
PKG_INSTALL:=0

# 关键3: 声明为架构无关构建
PKG_BUILD_PARALLEL:=1
PKG_ASLR_PIE:=0

include $(INCLUDE_DIR)/package.mk

define Package/axel
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=File Transfer
  TITLE:=Axel Download Accelerator
  # 关键4: 移除架构相关依赖
  DEPENDS:=+libopenssl +libpthread
  # 关键5: 标记为架构无关
  ARCH:=all
  URL:=https://github.com/axel-download-accelerator/axel
endef

define Package/axel/description
  Axel tries to accelerate HTTP/FTP downloading process by using multiple connections for one file.
  It can use multiple mirrors for a download. Axel has no dependencies and is lightweight,
  so it might be useful as a wget clone on byte-critical systems.
endef

# 关键6: 自定义构建过程
define Build/Compile
	# 多架构交叉编译
	$(foreach arch,$(ALL_MULTILIB_ARCHS),\
		$(MAKE) -C $(PKG_BUILD_DIR) clean; \
		$(MAKE) -C $(PKG_BUILD_DIR) \
			CC="$(TARGET_CC_$(arch))" \
			CFLAGS="$(TARGET_CFLAGS)" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			ARCH="$(arch)" \
			distclean configure; \
		$(MAKE) -C $(PKG_BUILD_DIR) \
			AUTOCONF=true \
			AUTOHEADER=true \
			AUTOM4TE=true \
			ACLOCAL=true \
			MAINTAINER_MODE=no; \
		mkdir -p $(PKG_BUILD_DIR)/bin/$(arch); \
		cp $(PKG_BUILD_DIR)/axel $(PKG_BUILD_DIR)/bin/$(arch)/; \
	)
endef

define Package/axel/install
	$(INSTALL_DIR) $(1)/usr/bin
	
	# 关键7: 安装多架构二进制
	$(foreach arch,$(ALL_MULTILIB_ARCHS),\
		$(INSTALL_DIR) $(1)/usr/bin/$(arch); \
		$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/$(arch)/axel $(1)/usr/bin/$(arch)/; \
	)
	
	# 安装通用启动脚本
	$(INSTALL_DIR) $(1)/usr/bin
	echo '#!/bin/sh' > $(1)/usr/bin/axel
	echo 'ARCH=$(call qstrip,$(CONFIG_ARCH))' >> $(1)/usr/bin/axel
	echo 'BIN_DIR="/usr/bin/$$ARCH"' >> $(1)/usr/bin/axel
	echo 'exec "$$BIN_DIR/axel" "$$@"' >> $(1)/usr/bin/axel
	chmod +x $(1)/usr/bin/axel
	
	# 安装示例配置文件
	$(INSTALL_DIR) $(1)/usr/share/axel
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/doc/axelrc.example $(1)/usr/share/axel/axelrc.example
endef

# 关键8: 声明为多架构兼容
define Package/axel/preinst
#!/bin/sh
# 检查架构兼容性
if [ -z "$$(grep "$$ARCH" /usr/bin/*/axel 2>/dev/null)" ]; then
	echo "Error: No binary for architecture $$ARCH"
	exit 1
fi
exit 0
endef

$(eval $(call BuildPackage,axel))
