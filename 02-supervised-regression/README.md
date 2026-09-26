# Supervised regression

Regression predicts a number. Here the target is a penguin's body mass in
grams.

The example compares four Create ML regressors:

| Algorithm | Basic idea | Good first use |
| --- | --- | --- |
| Linear regression | Fits one weighted equation | A fast baseline when relationships are roughly linear |
| Decision tree | Splits rows into groups and predicts within each group | Nonlinear patterns that are easy to inspect |
| Random forest | Averages the predictions of many trees | Reliable general-purpose structured-data modelling |
| Boosted trees | Adds trees that correct earlier errors | Often strong accuracy on tabular data |

The script randomly keeps 80% of complete rows for training and 20% for
testing. It reports root mean squared error (RMSE) in grams. Lower RMSE is
better; larger misses receive extra weight because the errors are squared.

## Run it

From `CreateML-Examples`:

```bash
swift run predict-penguin-mass
```

The complete source is in
[`Sources/Regression/main.swift`](../Sources/Regression/main.swift). It saves
the default and explicitly configured models in `Models/`.

## Set tree parameters explicitly

Leaving out `parameters` uses Create ML's defaults. You can instead construct
`ModelParameters` and pass them to the trainer. This configured random forest
uses more, deeper trees while retaining row and column sampling:

```swift
let forestParameters = MLRandomForestRegressor.ModelParameters(
    validation: .split(strategy: .automatic),
    maxDepth: 8,
    maxIterations: 100,
    minLossReduction: 0,
    minChildWeight: 0.1,
    randomSeed: 42,
    rowSubsample: 0.8,
    columnSubsample: 0.8
)

let randomForest = try MLRandomForestRegressor(
    trainingData: trainingData,
    targetColumn: target,
    featureColumns: features,
    parameters: forestParameters
)
```

Boosted trees add a `stepSize`, which controls how strongly each new tree
changes the ensemble, and optional early stopping when validation performance
stops improving:

```swift
let boostingParameters = MLBoostedTreeRegressor.ModelParameters(
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

let boostedTree = try MLBoostedTreeRegressor(
    trainingData: trainingData,
    targetColumn: target,
    featureColumns: features,
    parameters: boostingParameters
)
```

These values illustrate the API; they are not guaranteed to be best for a
different dataset. During a real parameter search, compare candidates using
validation data and reserve the test set for the final selected model.

## Change the target

To predict bill length instead, change `target` and make sure the old target is
not also listed as a feature:

```swift
let target = "bill_length_mm"
let features = [
    "species",
    "island",
    "bill_depth_mm",
    "flipper_length_mm",
    "body_mass_g",
    "sex",
    "year"
]
```

This target/feature separation matters. Accidentally including the answer in
the inputs is called target leakage and makes test results misleading.
