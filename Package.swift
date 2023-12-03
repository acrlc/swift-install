// swift-tools-version:5.5
import PackageDescription

let package = Package(
 name: "swift-install", platforms: [.macOS("13.3")],
 products: [.executable(name: "swift-install", targets: ["Install"])],
 dependencies: [
  .package(url: "https://github.com/codeAcrylic/shell.git", branch: "main")
 ],
 targets: [
  .executableTarget(
   name: "Install",
   dependencies: [.product(name: "Shell", package: "shell")],
   path: "Sources"
  )
 ]
)
