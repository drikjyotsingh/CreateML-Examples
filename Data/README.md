# Dataset notes

The data files in this directory keep the examples reproducible. They have
their own sources and licenses; they are not authored by this repository.

## `penguins.csv`

Real observations of 344 penguins from three species in the Palmer Archipelago,
collected from 2007–2009. The examples remove incomplete rows in memory before
training.

- Source: [palmerpenguins](https://allisonhorst.github.io/palmerpenguins/)
- Original file: `inst/extdata/penguins.csv`
- License: [CC0 1.0](https://allisonhorst.github.io/palmerpenguins/LICENSE.html)
- Citation: Horst AM, Hill AP, Gorman KB (2020), *palmerpenguins: Palmer
  Archipelago (Antarctica) penguin data*,
  [doi:10.5281/zenodo.3960218](https://doi.org/10.5281/zenodo.3960218)

The file is included unchanged from the package source.

## `restaurant_ratings.csv`

Real user-to-restaurant ratings from a recommender-system prototype. The
original `rating_final.csv` file has been renamed for clarity; its contents are
unchanged.

- Source: [UCI Restaurant & consumer data](https://archive.ics.uci.edu/dataset/232/restaurant%2Bconsumer%2Bdata)
- License: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Citation: Medellín, R. & Serna, J. (2011), *Restaurant & consumer data*, UCI
  Machine Learning Repository,
  [doi:10.24432/C5DP41](https://doi.org/10.24432/C5DP41)

The five columns are consumer ID, restaurant ID, overall rating, food rating,
and service rating. Ratings use the values 0, 1, and 2.
