// swift-tools-version:5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


// MARK: - Common

private enum OSPlatform: Equatable {
	case darwin     // macOS, iOS, tvOS, watchOS
	case linux      // ubuntu(16/18/20) / Amazon Linux 2
	case windows    // windows 10
	
#if os(macOS)
	static let current = OSPlatform.darwin
#elseif os(Linux)
	static let current = OSPlatform.linux
#else
#error("Unsupported platform.")
#endif
}

private func collectionElements<Element>(_ items: [[Element]]) -> [Element] {
	return items.flatMap { $0 }
}

private func conditionalElements<Element>(_ items: [Element], when platforms: [OSPlatform]) -> [Element] {
	if !platforms.contains(OSPlatform.current) {
		return []
	}
	return items
}


// MARK: - Package Config

let package = Package(
	name: "ShoutXerox",
	platforms: [
		.iOS(.v12),
		.macOS(.v10_15),
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "ShoutXerox",
			targets: ["ShoutXerox"]),
	],
	dependencies: collectionElements([
		// Dependencies declare other packages that this package depends on.
		conditionalElements([
			.package(name: "Socket", url: "https://github.com/Kitura/BlueSocket.git", .exact("2.0.2")),
		], when: [.linux]),
		conditionalElements([
			.package(url: "https://github.com/Kitura/BlueSocket.git", .exact("2.0.2")),
			.package(name: "CSSH", url: "https://github.com/DimaRU/Libssh2Prebuild.git", from: "1.9.0"),
		], when: [.darwin]),
	]),
	targets: collectionElements([
		[
			.target(
				name: "ShoutXerox",
				dependencies: collectionElements([
					[
						"CSSH"
					],
					conditionalElements([
						.product(name: "Socket", package: "BlueSocket"),
					], when: [.darwin]),
					conditionalElements([
						"Socket",
					], when: [.linux]),
				])
			),
			.testTarget(
				name: "ShoutXeroxTests",
				dependencies: ["ShoutXerox"]
			),
		],
		conditionalElements([
			.systemLibrary(
				name: "CSSH",
				pkgConfig: "libssh2",
				providers: [
					.apt(["libssh2 libssh2-dev"]),
				]),
		], when: [.linux]),
	])
)
