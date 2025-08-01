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
PKG_HASH:=575f73f640ee836a95d27b54aeed216c45bc1e914cad92da6f00b907d1c94925

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
	
	# 不安装默认配置文件
	# 用户可以手动创建需要的配置
endef

# 不需要配置文件部分
# define Package/axel/conffiles
# /etc/axelrc
# endef

$(eval $(call BuildPackage,axel))
