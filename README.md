# Create ML examples

Small, runnable Swift examples for learning Apple's
[Create ML](https://developer.apple.com/documentation/createml) framework. The
examples load real CSV data into a `TabularData.DataFrame`, train a model,
measure it on held-out rows, and save a Core ML `.mlmodel` file.

The code is intentionally direct. Each executable keeps the important steps in
one short `main.swift` file so it is easy to change a feature or swap an
algorithm.

## Example index

| Page | What it covers | Dataset |
| --- | --- | --- |
| [Supervised classification](01-supervised-classification/README.md) | Logistic regression, decision tree, random forest, boosted trees | Palmer Penguins |
| [Supervised regression](02-supervised-regression/README.md) | Linear regression, decision tree, random forest, boosted trees | Palmer Penguins |
| [Label-free recommendation](03-label-free-recommendation/README.md) | Collaborative filtering with `MLRecommender` | UCI restaurant ratings |
| [Create ML task map](04-create-ml-task-map/README.md) | Other supervised trainers and the limits of Create ML's unsupervised support | — |
| [SQL to DataFrame](05-sql-to-dataframe/README.md) | Where a database query fits before training | Your query result |

## Requirements

- A Mac running macOS 13 or newer
- Xcode or the Xcode Command Line Tools
- Swift 5.9 or newer

Create ML training is an Apple-platform feature. These examples do not require
Python or third-party Swift packages.

## Run the examples

From this directory:

```bash
swift run classify-penguins
swift run predict-penguin-mass
swift run recommend-restaurants
```

The first build takes a little longer. Trained models are written to the
git-ignored `Models/` directory.

You can also supply another compatible CSV file or output directory:

```bash
swift run classify-penguins --data /path/to/penguins.csv
swift run classify-penguins --output-dir /path/to/models
```

## The common pattern

All three examples follow the same short pipeline:

```swift
let data = try DataFrame(contentsOfCSVFile: csvURL)
let split = data.randomSplit(by: 0.8, seed: 42)

let model = try MLBoostedTreeRegressor(
    trainingData: DataFrame(split.0),
    targetColumn: "body_mass_g",
    featureColumns: ["bill_length_mm", "bill_depth_mm"]
)

let metrics = model.evaluation(on: DataFrame(split.1))
print(metrics.rootMeanSquaredError)
```

In a real project, spend more time cleaning the data, checking for leakage,
and choosing a test split that matches how the model will be used.

## Data and licensing

The bundled datasets are real, small enough for a tutorial, and independently
licensed. See [Data/README.md](Data/README.md) for sources, citations, and
license details. The example code is covered by this repository's Apache-2.0
license.
