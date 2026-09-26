// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "CreateMLExamples",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .executable(name: "classify-penguins", targets: ["Classification"]),
    .executable(name: "predict-penguin-mass", targets: ["Regression"]),
    .executable(name: "recommend-restaurants", targets: ["Recommendation"]),
  ],
  targets: [
    .target(name: "ExampleSupport"),
    .executableTarget(
      name: "Classification",
      dependencies: ["ExampleSupport"]
    ),
    .executableTarget(
      name: "Regression",
      dependencies: ["ExampleSupport"]
    ),
    .executableTarget(
      name: "Recommendation",
      dependencies: ["ExampleSupport"]
    ),
  ]
)
