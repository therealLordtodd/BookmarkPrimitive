// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BookmarkPrimitive",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "BookmarkPrimitive", targets: ["BookmarkPrimitive"]),
    ],
    targets: [
        .target(name: "BookmarkPrimitive"),
        .testTarget(
            name: "BookmarkPrimitiveTests",
            dependencies: ["BookmarkPrimitive"]
        ),
    ]
)
