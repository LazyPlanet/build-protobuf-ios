#!/bin/bash
TMP_DIR=/tmp/protobuf_$$
###################################################
# Build i386 version first, 
# Because arm needs it binary.
###################################################
CFLAGS=-m32 CPPFLAGS=-m32 CXXFLAGS=-m32 LDFLAGS=-m32 ./configure --prefix=${TMP_DIR}/i386 \
        --disable-shared \
        --enable-static || exit 1
make clean || exit 2
make -j8 || exit 3
make install || exit 4

###################################################
# iOS SDK location. 
###################################################

SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk
DEVROOT=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/
export CC=${DEVROOT}/usr/bin/clang
export CXX=${DEVROOT}/usr/bin/clang++

###################################################
# Build armv7 version, 
###################################################
export ARCH_TARGET="-arch armv7 -isysroot $SDKROOT"
export CFLAGS="${ARCH_TARGET}"
export CXXFLAGS="$CFLAGS -std=c++11 -stdlib=libc++"
export LDFLAGS="${ARCH_TARGET} -stdlib=libc++ -Wl,-syslibroot $SDKROOT"
./configure --prefix=$TMP_DIR/armv7 \
        --with-protoc=${TMP_DIR}/i386/bin/protoc \
        --disable-shared \
        --enable-static \
        --host=arm-apple-darwin10 || exit 1
make clean || exit 2
make -j8 || exit 3
make install || exit 4
###################################################
# Build armv7s version, 
###################################################
export ARCH_TARGET="-arch armv7s -isysroot $SDKROOT"
export CFLAGS="${ARCH_TARGET}"
export CXXFLAGS="$CFLAGS -std=c++11 -stdlib=libc++"
export LDFLAGS="${ARCH_TARGET} -stdlib=libc++ -Wl,-syslibroot $SDKROOT"
./configure --prefix=$TMP_DIR/armv7s \
        --with-protoc=${TMP_DIR}/i386/bin/protoc \
        --disable-shared \
        --enable-static \
        --host=arm-apple-darwin10 || exit 1
make clean || exit 2
make -j8 || exit 3
make install || exit 4
###################################################
# Packing
###################################################
DIST_DIR=$HOME/Desktop/protobuf_dist
rm -rf ${DIST_DIR}
mkdir -p ${DIST_DIR}
mkdir ${DIST_DIR}/{bin,lib}
cp -r ${TMP_DIR}/armv7/include ${DIST_DIR}/
cp ${TMP_DIR}/i386/bin/protoc ${DIST_DIR}/bin/
${DEVROOT}/usr/bin/lipo -arch i386 ${TMP_DIR}/i386/lib/libprotobuf.a -arch armv7 ${TMP_DIR}/armv7/lib/libprotobuf.a -arch armv7s ${TMP_DIR}/armv7s/lib/libprotobuf.a -output ${DIST_DIR}/lib/libprotobuf.a -create
