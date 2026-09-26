import CreateML
import ExampleSupport
import Foundation
import TabularData

let sourceURL = try dataURL(defaultRelativePath: "Data/restaurant_ratings.csv")
let data = try DataFrame(
  contentsOfCSVFile: sourceURL,
  types: [
    "userID": .string,
    "placeID": .string,
    "rating": .double,
    "food_rating": .double,
    "service_rating": .double,
  ]
)
let split = data.randomSplit(by: 0.8, seed: 42)
let trainingData = DataFrame(split.0)
let testingData = DataFrame(split.1)

// Create ML defaults to item-to-item collaborative filtering with cosine similarity.
let recommender = try MLRecommender(
  trainingData: trainingData,
  userColumn: "userID",
  itemColumn: "placeID",
  ratingColumn: "rating"
)

let metrics = recommender.evaluation(
  on: testingData,
  userColumn: "userID",
  itemColumn: "placeID",
  ratingColumn: "rating"
)
let outputURL = try modelOutputURL(fileName: "RestaurantRecommender.mlmodel")

try recommender.write(
  to: outputURL,
  metadata: metadata(
    description: "Recommends restaurants from consumer ratings.",
    dataset: "UCI Restaurant & consumer data (CC BY 4.0)"
  )
)

print(
  "Training with \(trainingData.shape.rows) ratings; testing with \(testingData.shape.rows) ratings."
)
print("Evaluation valid: \(metrics.isValid)")
if metrics.isValid {
  print("\nPrecision and recall by recommendation-list size:")
  if #available(macOS 14.0, *) {
    print(metrics.precisionRecallDataFrame)
  } else {
    print(metrics.precisionRecall)
  }
}
print("\nModel saved to \(outputURL.path)")
