// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "OrderedSet",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_13)
  ],
  products: [
    .library(
      name: "OrderedSet",
      targets: ["OrderedSet"])
  ],
  targets: [
    .target(
      name: "OrderedSet",
      path: "Sources/"),
    .testTarget(
      name: "OrderedSetTests",
      dependencies: ["OrderedSet"],
      path: "Tests/")
  ]
)
