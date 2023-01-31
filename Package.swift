// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BabbleiOS",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BabbleiOS",
            targets: ["BabbleiOS"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    
    targets: [
        .target(
            name: "BabbleiOS",
            path: "BabbleiOS")
//            exclude: [
//                "Example",
//                "LICENSE",
//                "BabbleiOS.podspec"
//            ])
        
    ]
)
