// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AcuityIQPackage",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AcuityIQPackage",
            targets: ["AcuityIQPackage"]),
    ],
    dependencies: [
//        .package(
//            url: "https://dev.azure.com/EnthralltechDevOps/IOS_APIManager/_git/IOS_APIManager",
//            .upToNextMinor(from: "1.0.0")
//        ),
        .package(path: "/Users/kashifhussain/Desktop/iOS_Network_Service/IOS_APIManager"),
//        .package(
//            url: "https://github.com/Hkashif722/SwiftUIUtility",
//            branch: "update"
//        ),
            .package(path: "/Users/kashifhussain/Desktop/OJT_New_Design/SwiftUIUtility/SwiftUIUtility"),
        .package(
            url: "https://github.com/danielgindi/Charts.git",
            .upToNextMajor(from: "5.1.0")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AcuityIQPackage",
            dependencies: [
                .product(name: "NetworkService", package: "IOS_APIManager"),
                .product(name: "SwiftUIUtilities", package: "SwiftUIUtility"),
                .product(name: "DGCharts", package: "Charts")
            ],
            resources: [
                .process("Resource/Media.xcassets")
            ]
        ),
        .testTarget(
            name: "AcuityIQPackageTests",
            dependencies: [
                "AcuityIQPackage",
                .product(name: "NetworkService", package: "IOS_APIManager")
            ]
        )
    ]
)
