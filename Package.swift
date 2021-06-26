// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TapIt",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]
        ),
        .library(
            name: "ComposablePhoneNumberValidation",
            targets: ["ComposablePhoneNumberValidation"]
        ),
        .library(
            name: "SharedModels",
            targets: ["SharedModels"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", .upToNextMajor(from: "0.19.0")),
        .package(name: "Overture", url: "https://github.com/pointfreeco/swift-overture", .upToNextMajor(from: "0.5.0")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.3.3")),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: [
                "AppFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ComposablePhoneNumberValidation",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
            ]
        ),
        .testTarget(
            name: "ComposablePhoneNumberValidationTests",
            dependencies: [
                "ComposablePhoneNumberValidation"
            ]
        ),
        .target(
            name: "SharedModels",
            dependencies: [
                .product(name: "Overture", package: "Overture"),
                .product(name: "PhoneNumberKit", package: "PhoneNumberKit"),
            ]
        ),
        .testTarget(
            name: "SharedModelsTests",
            dependencies: [
                "SharedModels",
            ]
        ),
    ]
)
