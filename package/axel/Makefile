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

# 关键修复：更新 config.sub 和 config.guess 文件
define Build/Prepare
	$(call Build/Prepare/Default)
	
	# 下载最新的 config.sub 和 config.guess
	$(SED) 's|ac_cv_env_.*_set||g' $(PKG_BUILD_DIR)/configure
	$(SED) 's|ac_cv_env_.*_value||g' $(PKG_BUILD_DIR)/configure
	$(SED) 's|abs_srcdir=.*||g' $(PKG_BUILD_DIR)/configure
	$(SED) 's|CC=.*||g' $(PKG_BUILD_DIR)/configure
	$(SED) 's|CXX=.*||g' $(PKG_BUILD_DIR)/configure
	wget -O $(PKG_BUILD_DIR)/config.sub 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
	wget -O $(PKG_BUILD_DIR)/config.guess 'https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
endef

define Build/Configure
	(cd $(PKG_BUILD_DIR); \
		[ -f configure ] || autoreconf -f -i; \
		$(call Build/Configure/Default) \
	)
endef

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
endef

$(eval $(call BuildPackage,axel))
