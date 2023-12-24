SYSROOT=/opt/flux
PREFIX=$(SYSROOT)/usr

all: all-binutils all-gdb all-gcc all-mlibc

install: install-binutils install-gdb install-gcc install-mlibc

clean: clean-binutils clean-gdb clean-gcc clean-mlibc

all-binutils:
	git clone https://sourceware.org/git/binutils-gdb.git || true
	git -C binutils-gdb reset --hard
	git -C binutils-gdb checkout binutils-2_41-release-point
	git -C binutils-gdb apply ../binutils.patch
	mkdir build-binutils
	cd build-binutils && \
		../binutils-gdb/configure \
		--target=riscv64-flux \
		--disable-gdb \
		--prefix=$(PREFIX) \
		--with-sysroot=$(SYSROOT)
	make -C build-binutils

install-bintutils:
	make -C build-binutils install

clean-binutils:
	rm -rf build-binutils

all-gdb:
	git clone https://sourceware.org/git/binutils-gdb.git || true
	git -C binutils-gdb reset --hard
	git -C binutils-gdb checkout gdb-13-branch
	git -C binutils-gdb apply ../gdb.patch
	mkdir build-gdb
	cd build-gdb && \
		../binutils-gdb/configure \
		--target=riscv64-flux \
		--prefix=$(PREFIX) \
		--with-sysroot=$(SYSROOT)
	make -C build-gdb all-gdb

install-gdb:
	make -C build-gdb install-gdb

clean-gdb:
	rm -rf build-gdb

all-gcc:
	git clone https://gcc.gnu.org/git/gcc.git || true
	git -C gcc checkout releases/gcc-13
	git -C gcc apply ../gcc.patch || true
	mkdir build-gcc
	cd build-gcc && \
		../gcc/configure \
		--target=riscv64-flux \
		--enable-languages=c,c++ \
		--without-headers \
		--disable-multilib \
		--prefix=$(PREFIX) \
		--with-sysroot=$(SYSROOT)
	make -C build-gcc all-gcc
	make -C build-gcc all-target-libgcc

install-gcc:
	make -C build-gcc install-gcc
	make -C build-gcc install-target-libgcc

clean-gcc:
	rm -rf build-gcc

all-mlibc-headers:
	git clone https://github.com/hextreme78/flux-mlibc.git || true
	cd flux-mlibc && \
		meson setup --prefix $(PREFIX) --cross-file riscv64-flux-headers.txt ../build-mlibc-headers
	cd build-mlibc-headers && \
		meson compile

install-mlibc-headers:
	cd build-mlibc-headers && \
		meson install

clean-mlibc-headers:
	rm -rf build-mlibc-headers

all-mlibc:
	git clone https://github.com/hextreme78/flux-mlibc.git || true
	cd flux-mlibc && \
		(meson setup --prefix $(PREFIX) --cross-file riscv64-flux.txt ../build-mlibc || true)
	cd build-mlibc && \
		meson compile

install-mlibc:
	cd build-mlibc && \
		meson install

clean-mlibc:
	rm -rf build-mlibc

