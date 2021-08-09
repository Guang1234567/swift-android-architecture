#!/usr/bin/env bash

export ANDROID_HOME=$HOME/dev_kit/sdk/android_sdk
export ANDROID_SDK=$ANDROID_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/20.1.5948944
export ANDROID_NDK=$ANDROID_NDK_HOME
export NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK_PATH=$ANDROID_NDK_HOME
export NDK_TOOLCHAINS=$HOME/dev_kit/sdk/toolchain-wrapper


 export SWIFT_ANDROID_HOME=$HOME/dev_kit/sdk/swift_source/swift-android-5.3.1-release-ndk20
 export SWIFT_ANDROID_ARCH=aarch64


 ${SWIFT_ANDROID_HOME}/build-tools/1.9.6-swift5/swift-build --configuration debug -Xswiftc -DDEBUG -Xswiftc -g



