// swift-tools-version:5.0

import Foundation
import PackageDescription

let packageName = "TodoCore"

// generated sources integration
let generatedName = "Generated"
let generatedPath = ".build/\(generatedName.lowercased())"

let isSourcesGenerated: Bool = {
    let basePath = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .path

    let fileManager = FileManager()
    fileManager.changeCurrentDirectoryPath(basePath)

    var isDirectory: ObjCBool = false
    let exists = fileManager.fileExists(atPath: generatedPath, isDirectory: &isDirectory)

    return exists && isDirectory.boolValue
}()

func addGenerated(_ products: [Product]) -> [Product] {
    if isSourcesGenerated == false {
        return products
    }

    return products + [
        .library(name: packageName, type: .dynamic, targets: [generatedName])
    ]
}

func addGenerated(_ targets: [Target]) -> [Target] {
    if isSourcesGenerated == false {
        return targets
    }

    return targets + [
        .target(
            name: generatedName,
            dependencies: [
                .byName(name: packageName),
                "java_swift",
                "Java",
                "JavaCoder"
            ],
            path: generatedPath
        )
    ]
}

// generated sources integration end

let package = Package(
    name: packageName,
    products: addGenerated([
    ]),
    dependencies: [
        .package(url: "https://hub.fastgit.org/readdle/java_swift.git", .exact("2.1.9")),
        .package(url: "https://hub.fastgit.org/readdle/swift-java.git", .exact("0.2.4")),
        .package(url: "https://hub.fastgit.org/readdle/swift-java-coder.git", .exact("1.0.17")),
        .package(url: "https://hub.fastgit.org/Guang1234567/swift-android-logcat.git", .branch("master")),
        // .package(path: "./third_part_libs/swift-android-logcat"),
        // .package(url: "./third_part_libs/swift-android-logcat", .branch("master"))
        .package(url: "https://hub.fastgit.org/Guang1234567/swift-android-trace.git", .branch("master")),
        // .package(path: "./third_part_libs/swift-android-trace"),
        .package(url: "https://hub.fastgit.org/Guang1234567/swift-backtrace.git", .branch("master")),
        // .package(path: "./third_part_libs/swift-backtrace"),
        .package(url: "https://hub.fastgit.org/Guang1234567/SQLite.swift.android.git", .branch("master")),
        // .package(path: "./third_part_libs/SQLite.swift.android"),
        .package(url: "https://hub.fastgit.org/Guang1234567/Swift-Posix-Thread.git", .branch("master")),
        // swift-transcode-tcforge.git has `git-submodule`
        // so need to call `.build/checkouts/swift-transcode-tcforge $ git submodule update  --recursive`.
        // [issue](https://github.com/apple/swift-package-manager/pull/756/commits/27db6d296fbd8a0f723c85ecf5397244c13a5325)
        .package(url: "https://hub.fastgit.org/Guang1234567/swift-transcode-tcforge.git", .branch("master")),
        .package(url: "https://hub.fastgit.org/Guang1234567/Swift_Android_Bitmap.git", .branch("master")),
        .package(url: "https://hub.fastgit.org/Guang1234567/Swift_Boost_Context.git", .branch("master")),
        .package(url: "https://hub.fastgit.org/Guang1234567/Swift_Coroutine.git", .branch("master"))
    ],
    targets: addGenerated([
        .target(name: packageName,
                dependencies: [
                    "java_swift",
                    "JavaCoder",
                    "AndroidSwiftLogcat",
                    "AndroidSwiftTrace",
                    "Backtrace",
                    "SQLite_swift_android",
                    "Swift-Posix-Thread",
                    "Avi",
                    "Swift_Android_Bitmap",
                    "Swift_Boost_Context",
                    "Swift_Coroutine"
                ])
    ])
)
