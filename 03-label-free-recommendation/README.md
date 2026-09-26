# Label-free recommendation

A recommender learns which items tend to suit which users. This example uses
real consumer-to-restaurant ratings and Create ML's `MLRecommender`.

There is no separate target column such as `species` or `body_mass_g`. Instead,
the model learns from three columns:

- `userID`: who supplied the feedback
- `placeID`: which restaurant they rated
- `rating`: how strongly they liked it, from 0 to 2

This is collaborative filtering: similar user-item interaction patterns help
the model rank unseen items. It is often described as unsupervised or
label-free because there is no hand-authored class label. More precisely, the
rating is still a feedback signal, so recommendation is not the same thing as
general clustering.

## Which algorithm does Apple use?

`MLRecommender` uses **item-to-item collaborative filtering**. It compares
items by the users who interacted with them and, when present, the ratings
those users supplied. The default configuration is item similarity with
**cosine similarity**; Create ML also supports Jaccard similarity and Pearson
correlation. This is a nearest-items approach, not matrix factorization or a
neural recommender. See Apple's documentation for
[`ModelAlgorithmType`](https://developer.apple.com/documentation/createml/mlrecommender/modelalgorithmtype)
and [`SimilarityType`](https://developer.apple.com/documentation/createml/mlrecommender/similaritytype).

## Run it

From `CreateML-Examples`:

```bash
swift run recommend-restaurants
```

The complete source is in
[`Sources/Recommendation/main.swift`](../Sources/Recommendation/main.swift).
It uses an 80/20 split, prints precision/recall information when evaluation is
valid, and saves `Models/RestaurantRecommender.mlmodel`.

## Explicit and implicit feedback

This example passes a `ratingColumn`, so it uses explicit feedback. For a CSV
that records interactions but has no rating—purchases, plays, or clicks—omit
that argument:

```swift
let recommender = try MLRecommender(
    trainingData: interactions,
    userColumn: "userID",
    itemColumn: "placeID"
)
```

For useful results, each user and item needs enough interactions. A large pile
of one-off users or items gives the model very little shared structure to
learn.
