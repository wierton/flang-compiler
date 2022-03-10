.PHONY: libpgmath flang-driver libflang

BUILDDIR := $(CURDIR)/../flang-compile
$(shell mkdir -p $(BUILDDIR))
DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
LIBDIR=/usr/lib/$(DEB_HOST_MULTIARCH)

libpgmath:
	mkdir -p $(BUILDDIR)/libpgmath
	cd $(BUILDDIR)/libpgmath && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -DLIBPGMATH_LLVM_LIT_EXECUTABLE=/usr/lib/llvm-7/build/utils/lit/lit.py \
	  $(CURDIR)/runtime/libpgmath && \
	  $(MAKE) VERBOSE=1 install DESTDIR=$(BUILDDIR)/libpgmath/lib -j32

flang-driver: libpgmath
	mkdir -p $(BUILDDIR)/flang-driver
	cd $(BUILDDIR)/flang-driver && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -DLINK_POLLY_INTO_TOOLS=False \
	  -DLLVM_CONFIG=/usr/lib/llvm-7/bin/llvm-config \
	  $(CURDIR)/flang-driver &&  \
	  $(MAKE) VERBOSE=1 DESTDIR=$(CURDIR)/flang-driver -j32

libflang:
	mkdir -p $(BUILDDIR)/libflang
	cd $(BUILDDIR)/libflang && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -DCMAKE_Fortran_COMPILER=/usr/bin/gfortran \
	  -DCMAKE_Fortran_COMPILER_ID=gfortran \
	  -DLLVM_CONFIG=/usr/lib/llvm-7/bin/llvm-config \
	  -DFLANG_LIBOMP=$(LIBDIR)/libomp5.so	\
	  -DLIBPGMATH=$(BUILDDIR)/libpgmath/lib/libpgmath.so \
	  $(CURDIR) && \
	  $(MAKE) VERBOSE=1 DESTDIR=$(CURDIR)/libflang
