# Supervised classification

Classification predicts a category. Here the category is a penguin's species:
Adelie, Chinstrap, or Gentoo.

The example compares four current Create ML tabular classifiers:

| Algorithm | Basic idea | Good first use |
| --- | --- | --- |
| Logistic regression | Learns a simple weighted boundary between classes | A fast, understandable baseline |
| Decision tree | Repeatedly splits rows using feature rules | Small data and easy-to-follow rules |
| Random forest | Averages many varied decision trees | A strong general-purpose model with little tuning |
| Boosted trees | Builds trees in sequence, correcting earlier mistakes | Often strong accuracy on structured data |

The script removes rows with missing values, keeps 80% for training, and holds
out 20% for testing. Its split is stratified, so each species stays represented
in both parts. Accuracy is the percentage of held-out penguins assigned the
correct species.

## Run it

From `CreateML-Examples`:

```bash
swift run classify-penguins
```

The complete source is in
[`Sources/Classification/main.swift`](../Sources/Classification/main.swift).
It saves one `.mlmodel` file for each algorithm in `Models/`.

## Change the experiment

The target and features are ordinary strings:

```swift
let target = "species"
let features = [
    "island",
    "bill_length_mm",
    "bill_depth_mm",
    "flipper_length_mm",
    "body_mass_g",
    "sex",
    "year"
]
```

Remove one feature, run the example again, and compare the test accuracy. That
is a simple way to see whether the model was relying on it.

> Create ML also contains a legacy support-vector classifier API, but it has
> been deprecated on recent macOS SDKs. This example uses the current tabular
> classifier APIs so it builds without relying on that older trainer.
