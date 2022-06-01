// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Chary",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v10)
    ],
    products: [
        .library(
            name: "Chary",
            targets: ["Chary"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Quick.git", from: "5.0.1"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "10.0.0")
    ],
    targets: [
        .target(
            name: "Chary",
            dependencies: [],
            path: "Chary/Classes"
        ),
        .testTarget(
            name: "CharyTests",
            dependencies: [
                "Chary", "Quick", "Nimble"
            ],
            path: "Example/Tests",
            exclude: ["Info.plist"]
        )
    ]
)
