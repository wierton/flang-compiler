.PHONY: libpgmath flang-driver libflang

BUILDDIR ?= $(CURDIR)/output
$(shell mkdir -p $(BUILDDIR))
DEB_HOST_MULTIARCH ?= $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)
LIBDIR=/usr/lib/$(DEB_HOST_MULTIARCH)

GFORTRAN != which gfortran
LLVM_CONFIG ?= $(shell which llvm-config-7)
LLVM_LIT_PY != $(shell $(LLVM_CONFIG) --obj-root)/utils/lit/lit.py

CMAKE_FLAGS=
ifdef CMAKE_C_FLAGS
CMAKE_FLAGS += -DCMAKE_C_FLAGS=$(CMAKE_C_FLAGS)
endif
ifdef CMAKE_CXX_FLAGS
CMAKE_FLAGS += -DCMAKE_CXX_FLAGS=$(CMAKE_CXX_FLAGS)
endif
ifdef CMAKE_C_COMPILER
CMAKE_FLAGS += -DCMAKE_C_COMPILER=$(CMAKE_C_COMPILER)
endif
ifdef CMAKE_CXX_COMPILER
CMAKE_FLAGS += -DCMAKE_CXX_COMPILER=$(CMAKE_CXX_COMPILER)
endif

libpgmath:
	mkdir -p $(BUILDDIR)/libpgmath
	cd $(BUILDDIR)/libpgmath && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
		$(CMAKE_FLAGS) \
	  -DLIBPGMATH_LLVM_LIT_EXECUTABLE=$(LLVM_LIT_PY) \
	  $(CURDIR)/runtime/libpgmath && \
	  $(MAKE) VERBOSE=1 install DESTDIR=$(BUILDDIR)/libpgmath/lib

flang-driver:
	mkdir -p $(BUILDDIR)/flang-driver
	cd $(BUILDDIR)/flang-driver && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -DLINK_POLLY_INTO_TOOLS=False \
	  -DLLVM_CONFIG=$(LLVM_CONFIG) \
		$(CMAKE_FLAGS) \
	  $(CURDIR)/flang-driver &&  \
	  $(MAKE) VERBOSE=1 DESTDIR=$(CURDIR)/flang-driver -j8

libflang:
	rm -rf $(BUILDDIR)/libflang
	mkdir -p $(BUILDDIR)/libflang
	cd $(BUILDDIR)/libflang && cmake \
	  -DWITH_WERROR=OFF \
	  -DCMAKE_VERBOSE_MAKEFILE=ON \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  -DCMAKE_Fortran_COMPILER=$(GFORTRAN) \
	  -DCMAKE_Fortran_COMPILER_ID=gfortran \
	  -DLLVM_CONFIG=$(LLVM_CONFIG) \
	  -DFLANG_LIBOMP=$(LIBDIR)/libomp5.so	\
	  -DLIBPGMATH=$(BUILDDIR)/libpgmath/lib/libpgmath.so \
	  $(CURDIR) && \
	  $(MAKE) VERBOSE=1 DESTDIR=$(CURDIR)/libflang
