cache()
include(spot-on-kernel-source.pro)
libntru.commands = $(MAKE) -C ../../../libNTRU
libntru.depends =
libntru.target = libntru.dylib
libspoton.commands = $(MAKE) -C ../../../libSpotOn library
libspoton.depends =
libspoton.target = libspoton.dylib
purge.commands = rm -f *~

CONFIG		+= qt release warn_on app_bundle
LANGUAGE	= C++
QT		+= bluetooth concurrent network sql websockets
QT              -= gui

DEFINES += SPOTON_BLUETOOTH_ENABLED \
           SPOTON_DTLS_DISABLED \
           SPOTON_LINKED_WITH_LIBGEOIP \
           SPOTON_LINKED_WITH_LIBNTRU \
	   SPOTON_LINKED_WITH_LIBPTHREAD \
           SPOTON_MCELIECE_ENABLED \
           SPOTON_POPTASTIC_SUPPORTED \
	   SPOTON_WEBSOCKETS_ENABLED

# Unfortunately, the clean target assumes too much knowledge
# about the internals of libNTRU and libSpotOn.

QMAKE_CLEAN            += ../../../libNTRU/*.dylib \
                          ../../../libNTRU/src/*.o \
                          ../../../libNTRU/src/*.s \
                          ../../../libSpotOn/*.dylib \
                          ../../../libSpotOn/*.o \
                          ../../../libSpotOn/test \
                          ../Spot-On-Kernel
QMAKE_CXX              = clang++
QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_CXXFLAGS_RELEASE += -O3 \
                          -Wall \
                          -Wcast-qual \
                          -Wdouble-promotion \
                          -Wextra \
                          -Wno-cast-align \
                          -Wno-deprecated \
                          -Wno-unused-parameter \
                          -Woverloaded-virtual \
                          -Wpointer-arith \
                          -Wstack-protector \
                          -Wstrict-overflow=5 \
                          -fPIE \
                          -fstack-protector-all \
                          -fwrapv \
                          -mtune=generic \
                          -pedantic \
                          -std=c++11
QMAKE_DISTCLEAN        += -r temp .qmake.cache .qmake.stash
QMAKE_EXTRA_TARGETS    = libntru libspoton purge
QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.12

ICON		  =
INCLUDEPATH	  += . \
                     ../. ../../../. \
                     /usr/local/Cellar/openssl@1.1/1.1.1i/include \
                     /usr/local/include /usr/local/opt \
                     /usr/local/opt/curl/include
LIBS		  += -L../../../libNTRU \
                     -L../../../libSpotOn \
                     -L/usr/local/Cellar/openssl@1.1/1.1.1i/lib \
                     -L/usr/local/lib \
                     -L/usr/local/opt/curl/lib \
                     -framework Cocoa \
                     -lGeoIP \
                     -lcrypto \
                     -lcurl \
                     -lgcrypt \
                     -lgmp \
                     -lgpg-error \
                     -lntl \
                     -lntru \
                     -lpq \
                     -lspoton \
                     -lssl
MOC_DIR           = temp/moc
OBJECTIVE_HEADERS += ../Common/CocoaInitializer.h
OBJECTIVE_SOURCES += ../Common/CocoaInitializer.mm
OBJECTS_DIR       = temp/obj
PRE_TARGETDEPS    = libntru.dylib libspoton.dylib
PROJECTNAME	  = Spot-On-Kernel
RCC_DIR           = temp/rcc
TARGET		  = ../Spot-On-Kernel
TEMPLATE          = app
UI_DIR            = temp/ui

# Prevent qmake from stripping everything.

QMAKE_STRIP	= echo

copyspoton.extra            = cp -r ../Spot-On-Kernel.app /Applications/Spot-On.d/.
copyspoton.path             = /Applications/Spot-On.d
copyssl.extra               = cp /usr/local/Cellar/openssl@1.1/1.1.1i/lib/*.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/Frameworks/.
copyssl.path                = /Applications/Spot-On.d
install_name_tool.extra     = install_name_tool -change /usr/local/Cellar/openssl@1.1/1.1.1i/lib/libcrypto.1.1.dylib @executable_path/../Frameworks/libcrypto.1.1.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/Frameworks/libssl.1.1.dylib
install_name_tool.path      = .
libgeoip_data_install.files = ../../../GeoIP/Data/GeoIP.dat
libgeoip_data_install.path  = /Applications/Spot-On.d/GeoIP
libntru_install.extra       = cp ../../../libNTRU/libntru.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/Frameworks/libntru.dylib && install_name_tool -change libntru.dylib @executable_path/../Frameworks/libntru.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
libntru_install.path        = .
libspoton_install.extra     = cp ../../../libSpotOn/libspoton.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/Frameworks/libspoton.dylib && install_name_tool -change /usr/local/opt/libgcrypt/lib/libgcrypt.20.dylib @loader_path/libgcrypt.20.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/Frameworks/libspoton.dylib && install_name_tool -change libspoton.dylib @executable_path/../Frameworks/libspoton.dylib /Applications/Spot-On.d/Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
libspoton_install.path      = .
macdeployqt.extra           = $$[QT_INSTALL_BINS]/macdeployqt /Applications/Spot-On.d/Spot-On-Kernel.app -executable=/Applications/Spot-On.d/Spot-On-Kernel.app/Contents/MacOS/Spot-On-Kernel
macdeployqt.path            = Spot-On-Kernel.app
preinstall.extra            = rm -rf /Applications/Spot-On.d/Spot-On-Kernel.app/*
preinstall.path             = /Applications/Spot-On.d

# Order is important.

INSTALLS	= preinstall \
                  copyspoton \
                  macdeployqt \
                  copyssl \
                  install_name_tool \
                  libgeoip_data_install \
                  libntru_install \
                  libspoton_install
