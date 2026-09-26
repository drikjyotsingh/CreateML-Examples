import CreateML
import ExampleSupport
import Foundation
import TabularData

let sourceURL = try dataURL(defaultRelativePath: "Data/penguins.csv")
let data = try loadCompletePenguins(from: sourceURL)
let split = data.randomSplit(by: 0.8, seed: 42)
let trainingData = DataFrame(split.0)
let testingData = DataFrame(split.1)

let target = "body_mass_g"
let features = [
  "species",
  "island",
  "bill_length_mm",
  "bill_depth_mm",
  "flipper_length_mm",
  "sex",
  "year",
]
let modelMetadata = metadata(
  description: "Predicts a Palmer penguin's body mass in grams.",
  dataset: "Palmer Penguins (CC0)"
)

func report(
  name: String,
  fileName: String,
  metrics: MLRegressorMetrics,
  save: (URL) throws -> Void
) throws {
  let outputURL = try modelOutputURL(fileName: fileName)
  try save(outputURL)

  print("\(name): test RMSE \(String(format: "%.1f", metrics.rootMeanSquaredError)) g")
  print("  saved to \(outputURL.path)")
}

print(
  "Training with \(trainingData.shape.rows) rows; testing with \(testingData.shape.rows) rows.\n")

let linearRegression = try MLLinearRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Linear regression",
  fileName: "PenguinLinearRegression.mlmodel",
  metrics: linearRegression.evaluation(on: testingData)
) { try linearRegression.write(to: $0, metadata: modelMetadata) }

let decisionTree = try MLDecisionTreeRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Decision tree",
  fileName: "PenguinDecisionTreeRegressor.mlmodel",
  metrics: decisionTree.evaluation(on: testingData)
) { try decisionTree.write(to: $0, metadata: modelMetadata) }

let randomForest = try MLRandomForestRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Random forest",
  fileName: "PenguinRandomForestRegressor.mlmodel",
  metrics: randomForest.evaluation(on: testingData)
) { try randomForest.write(to: $0, metadata: modelMetadata) }

let boostedTree = try MLBoostedTreeRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Boosted trees",
  fileName: "PenguinBoostedTreeRegressor.mlmodel",
  metrics: boostedTree.evaluation(on: testingData)
) { try boostedTree.write(to: $0, metadata: modelMetadata) }

// These are illustrative settings, not automatically optimal values.
print("\nTraining explicitly configured tree models.\n")

let configuredForestParameters = MLRandomForestRegressor.ModelParameters(
  validation: .split(strategy: .automatic),
  maxDepth: 8,
  maxIterations: 100,
  minLossReduction: 0,
  minChildWeight: 0.1,
  randomSeed: 42,
  rowSubsample: 0.8,
  columnSubsample: 0.8
)
let configuredRandomForest = try MLRandomForestRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features,
  parameters: configuredForestParameters
)
try report(
  name: "Configured random forest",
  fileName: "PenguinConfiguredRandomForestRegressor.mlmodel",
  metrics: configuredRandomForest.evaluation(on: testingData)
) { try configuredRandomForest.write(to: $0, metadata: modelMetadata) }

let configuredBoostingParameters = MLBoostedTreeRegressor.ModelParameters(
  validation: .split(strategy: .automatic),
  maxDepth: 4,
  maxIterations: 100,
  minLossReduction: 0,
  minChildWeight: 0.1,
  randomSeed: 42,
  stepSize: 0.1,
  earlyStoppingRounds: 10,
  rowSubsample: 0.8,
  columnSubsample: 0.8
)
let configuredBoostedTree = try MLBoostedTreeRegressor(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features,
  parameters: configuredBoostingParameters
)
try report(
  name: "Configured boosted trees",
  fileName: "PenguinConfiguredBoostedTreeRegressor.mlmodel",
  metrics: configuredBoostedTree.evaluation(on: testingData)
) { try configuredBoostedTree.write(to: $0, metadata: modelMetadata) }
