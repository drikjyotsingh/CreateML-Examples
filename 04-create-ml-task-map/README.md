# Create ML task map

Create ML is a task-focused training framework rather than a general catalogue
of every machine-learning algorithm. Start with the kind of output you need:

| Goal | Main Create ML type | Typical training data |
| --- | --- | --- |
| Predict a category from table columns | `MLLogisticRegressionClassifier`, `MLDecisionTreeClassifier`, `MLRandomForestClassifier`, `MLBoostedTreeClassifier` | CSV / `DataFrame` with a label column |
| Predict a number from table columns | `MLLinearRegressor`, `MLDecisionTreeRegressor`, `MLRandomForestRegressor`, `MLBoostedTreeRegressor` | CSV / `DataFrame` with a numeric target |
| Classify text | `MLTextClassifier` | Text plus a class label |
| Tag words in text | `MLWordTagger` | Token sequences plus a tag for each token |
| Classify images | `MLImageClassifier` | Image folders grouped by label |
| Locate objects in images | `MLObjectDetector` | Images plus bounding-box annotations |
| Classify sounds | `MLSoundClassifier` | Audio files grouped by label |
| Classify motion or actions | `MLActivityClassifier`, `MLActionClassifier`, `MLHandActionClassifier`, `MLHandPoseClassifier` | Sensor or annotated video/image data |
| Recommend items | `MLRecommender` | User-item interactions, optionally with ratings |
| Learn an image style transformation | `MLStyleTransfer` | Content images plus a style image |

Apple's [Create ML documentation](https://developer.apple.com/documentation/createml)
lists the full API and platform availability.

## What about unsupervised learning?

Create ML's public training API does not provide general-purpose K-means,
hierarchical clustering, DBSCAN, PCA, or t-SNE trainers. Do not rename a
supervised classifier as “clustering”; the input and evaluation are different.

`MLRecommender` is the main label-free learning example in this folder. Create
ML also has `MLWordEmbedding`, but that type packages an existing word-vector
dictionary as a Core ML model rather than learning clusters from raw text.

If a project needs general clustering or dimensionality reduction, perform
that analysis with a numerical or scientific-ML library. Create ML remains a
good fit for the supervised and recommendation tasks above, and the resulting
models can be saved for use with Core ML in an app.
