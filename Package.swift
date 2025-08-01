// swift-tools-version:5.6
import PackageDescription

let package = Package(
	name: "orderedset",
	platforms: [
		.iOS(.v14),
		.tvOS(.v14),
		.macCatalyst(.v14),
		.macOS(.v11),
		.watchOS(.v8)
	],
	products: [
		.library(
			name: "OrderedSet",
			targets: ["OrderedSet"]
		)
	],
	targets: [
		.target(
			name: "OrderedSet",
			path: "Sources/"
		),
		.testTarget(
			name: "OrderedSetTests",
			dependencies: ["OrderedSet"],
			path: "Tests/"
		)
	]
)
