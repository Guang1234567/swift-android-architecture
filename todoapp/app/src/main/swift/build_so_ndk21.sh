#!/usr/bin/env bash

export ANDROID_HOME=$HOME/dev_kit/sdk/android_sdk
export ANDROID_SDK=$ANDROID_HOME
export ANDROID_SDK_ROOT=$ANDROID_HOME
export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/21.4.7075529
export ANDROID_NDK=$ANDROID_NDK_HOME
export NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK_ROOT=$ANDROID_NDK_HOME
export ANDROID_NDK_PATH=$ANDROID_NDK_HOME
export NDK_TOOLCHAINS=$HOME/dev_kit/sdk/toolchain-wrapper


export SWIFT_ANDROID_HOME=$HOME/dev_kit/sdk/swift_android_all_in_one/swift-android-5.4.2-release-ndk21
export SWIFT_ANDROID_ARCH=aarch64
#export SWIFT_ANDROID_ARCH=armv7
#export SWIFT_ANDROID_ARCH=x86_64


${SWIFT_ANDROID_HOME}/build-tools/1.9.7-swift5.4/swift-build --configuration debug -Xswiftc -DDEBUG -Xswiftc -g



