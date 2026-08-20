// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "DevWifiBar",
    platforms: [
        .macOS(.v14),
    ],
    products: [
        .library(name: "DevWifiCore", targets: ["DevWifiCore"]),
        .executable(name: "DevWifiBar", targets: ["DevWifiBar"]),
    ],
    targets: [
        .target(
            name: "DevWifiCore",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .executableTarget(
            name: "DevWifiBar",
            dependencies: ["DevWifiCore"],
            exclude: ["Info.plist"],
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "DevWifiCoreTests",
            dependencies: ["DevWifiCore"],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]
        ),
    ]
)
