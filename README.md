build-protobuf-ios
==================

Build Google Protobuf for iOS development
Only build script, please find Google Protobuf here: http://code.google.com/p/protobuf/

Tested on iOS SDK 8.1 on MacOSX 10.8
Tested Google Protobuf 2.6.1<br />
** If older version 2.5.0 is needed, check the repoisitory history and find patch-arm64.patch

Binary output will be on your Desktop and named "protobuf_dist"

Usage
=================
```
curl -O https://protobuf.googlecode.com/files/protobuf-2.6.1.tar.bz2
tar xf protobuf-2.6.1.tar.bz2
cd protobuf-2.6.1
curl https://raw.githubusercontent.com/sinofool/build-protobuf-ios/master/build_protobuf_dist.sh |bash
......
```

