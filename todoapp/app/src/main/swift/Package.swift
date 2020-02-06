// swift-tools-version:5.0
import PackageDescription
import Foundation

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
                "JavaCoder",
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
        .package(url: "https://github.com/readdle/java_swift.git", .exact("2.1.9")),
        .package(url: "https://github.com/readdle/swift-java.git", .exact("0.2.4")),
        .package(url: "https://github.com/readdle/swift-java-coder.git", .exact("1.0.17")),
        .package(url: "https://github.com/Guang1234567/swift-android-logcat.git", .branch("master")),
        //.package(path: "./third_part_libs/swift-android-logcat"),
        //.package(url: "./third_part_libs/swift-android-logcat", .branch("master"))
        .package(url: "https://github.com/Guang1234567/swift-android-trace.git", .branch("master")),
        //.package(path: "./third_part_libs/swift-backtrace"),
        .package(url: "https://github.com/Guang1234567/swift-backtrace.git", .branch("master")),
        //.package(path: "./third_part_libs/SwiftBacktrace"),
    ],
    targets: addGenerated([
        .target(name: packageName,
                dependencies: [
                    "java_swift",
                    "JavaCoder",
                    "AndroidSwiftLogcat",
                    "AndroidSwiftTrace",
                    "Backtrace",
                    //"SwiftBacktrace",
                ]
        )
    ])
)