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
one `.mlmodel` file for each algorithm in `Models/`.

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
