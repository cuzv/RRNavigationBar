// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RRNavigationBar",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RRNavigationBar", targets: ["RRNavigationBar"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RRNavigationBar",
            path: "Sources",
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("Internal"),
            ]
        ),
    ]
)
