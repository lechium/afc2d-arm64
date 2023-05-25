TARGET =: clang::7.0
ARCHS = arm64
target = appletv
THEOS_DEVICE_IP=bedroom.local
DEBUG = 1
GO_EASY_ON_ME = 1

THEOS_PACKAGE_DIR_NAME = debs
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

include $(THEOS)/makefiles/common.mk

#TOOL_NAME = postrm killdaemon

#postrm_FILES = postrm.mm
#postrm_FRAMEWORKS = Foundation
#postrm_INSTALL_PATH = /tmp
#postrm_CODESIGN_FLAGS = -Sentitlements.xml

TOOL_NAME = killdaemon

killdaemon_FILES = killdaemon.mm
killdaemon_INSTALL_PATH =/fs/jb/usr/bin
killdaemon_LIBRARIES = z
killdaemon_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tool.mk

TWEAK_NAME = afc2dService afc2dSupport

afc2dService_FILES = afc2dService.xm
afc2dService_INSTALL_PATH = /fs/jb/Library/MobileSubstrate/DynamicLibraries
afc2dService_LIBRARIES = substrate

afc2dSupport_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-stage::
	#mv -f $(THEOS_STAGING_DIR)/tmp/postrm ./layout/DEBIAN/postrm
	#rm -Rf $(THEOS_STAGING_DIR)/tmp

before-package::
	sudo rm -rf $(THEOS_STAGING_DIR)/Library
	sudo rm -rf $(THEOS_STAGING_DIR)/usr
	sudo chown -R root:wheel $(THEOS_STAGING_DIR)
	sudo chmod -R 755 $(THEOS_STAGING_DIR)
	sudo chmod 666 $(THEOS_STAGING_DIR)/DEBIAN/control

after-package::
	make clean
	sudo mv .theos/_ $(THEOS_PACKAGE_NAME)_$(THEOS_PACKAGE_BASE_VERSION)_appletvos-arm64
	zip -r .theos/$(THEOS_PACKAGE_NAME)_$(THEOS_PACKAGE_BASE_VERSION)_appletvos-arm64.zip $(THEOS_PACKAGE_NAME)_$(THEOS_PACKAGE_BASE_VERSION)_appletvos-arm64
	mv .theos/$(THEOS_PACKAGE_NAME)_$(THEOS_PACKAGE_BASE_VERSION)_appletvos-arm64.zip ./
	sudo rm -rf $(THEOS_PACKAGE_NAME)_$(THEOS_PACKAGE_BASE_VERSION)_appletvos-arm64

after-install::
	install.exec "killall -9 backboardd"
