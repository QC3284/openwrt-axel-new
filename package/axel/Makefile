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

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/axel-download-accelerator/axel/releases/download/v$(PKG_VERSION)/
PKG_HASH:=d5a1e6a9a7d9c1b8b6d7c9a0b5c6d7e8f9a0b1c2d3e4f5a6b7c8d9e0f1a2b3c4

PKG_MAINTAINER:=Gianluigi Tiesi <sherpya@netfarm.it>
PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=COPYING

PKG_INSTALL:=1
PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/axel
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=File Transfer
  TITLE:=Axel Download Accelerator
  DEPENDS:=+libopenssl +libpthread
  URL:=https://github.com/axel-download-accelerator/axel
endef

define Package/axel/description
  Axel tries to accelerate HTTP/FTP downloading process by using multiple connections for one file.
  It can use multiple mirrors for a download. Axel has no dependencies and is lightweight,
  so it might be useful as a wget clone on byte-critical systems.
endef

CONFIGURE_ARGS += \
	--prefix=/usr

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		AUTOCONF=true \
		AUTOHEADER=true \
		AUTOM4TE=true \
		ACLOCAL=true \
		MAINTAINER_MODE=no \
		$(MAKE_FLAGS)
endef

define Package/axel/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/axel $(1)/usr/bin/
	
	# 可选：安装示例配置文件（不作为默认配置）
	$(INSTALL_DIR) $(1)/usr/share/axel
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/doc/axelrc.example $(1)/usr/share/axel/axelrc.example
endef

# 不需要定义 conffiles

$(eval $(call BuildPackage,axel))
