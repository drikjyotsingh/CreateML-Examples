import CreateML
import ExampleSupport
import Foundation
import TabularData

let sourceURL = try dataURL(defaultRelativePath: "Data/penguins.csv")
let data = try loadCompletePenguins(from: sourceURL)
let (trainingData, testingData) = data.stratifiedSplit(
  on: "species",
  by: 0.8,
  randomSeed: 42
)

let target = "species"
let features = [
  "island",
  "bill_length_mm",
  "bill_depth_mm",
  "flipper_length_mm",
  "body_mass_g",
  "sex",
  "year",
]
let modelMetadata = metadata(
  description: "Classifies Palmer penguin species from physical measurements.",
  dataset: "Palmer Penguins (CC0)"
)

func report(
  name: String,
  fileName: String,
  metrics: MLClassifierMetrics,
  save: (URL) throws -> Void
) throws {
  let accuracy = (1.0 - metrics.classificationError) * 100.0
  let outputURL = try modelOutputURL(fileName: fileName)
  try save(outputURL)

  print("\(name): \(String(format: "%.1f", accuracy))% test accuracy")
  print("  saved to \(outputURL.path)")
}

print(
  "Training with \(trainingData.shape.rows) rows; testing with \(testingData.shape.rows) rows.\n")

let logisticRegression = try MLLogisticRegressionClassifier(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Logistic regression",
  fileName: "PenguinLogisticRegression.mlmodel",
  metrics: logisticRegression.evaluation(on: testingData)
) { try logisticRegression.write(to: $0, metadata: modelMetadata) }

let decisionTree = try MLDecisionTreeClassifier(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Decision tree",
  fileName: "PenguinDecisionTree.mlmodel",
  metrics: decisionTree.evaluation(on: testingData)
) { try decisionTree.write(to: $0, metadata: modelMetadata) }

let randomForest = try MLRandomForestClassifier(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Random forest",
  fileName: "PenguinRandomForest.mlmodel",
  metrics: randomForest.evaluation(on: testingData)
) { try randomForest.write(to: $0, metadata: modelMetadata) }

let boostedTree = try MLBoostedTreeClassifier(
  trainingData: trainingData,
  targetColumn: target,
  featureColumns: features
)
try report(
  name: "Boosted trees",
  fileName: "PenguinBoostedTrees.mlmodel",
  metrics: boostedTree.evaluation(on: testingData)
) { try boostedTree.write(to: $0, metadata: modelMetadata) }
