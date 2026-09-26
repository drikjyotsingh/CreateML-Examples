# SQL to DataFrame

Create ML does not open a SQL database itself. A database driver runs the
query, and ordinary Swift arrays become columns in a `DataFrame`:

```text
SQL database → Swift database driver → arrays → DataFrame → Create ML model
```

The database-specific part is deliberately small. The shape is:

```swift
import CreateML
import TabularData

// Fill these arrays from rows returned by your database driver.
var billLength: [Double] = []
var billDepth: [Double] = []
var bodyMass: [Int] = []

let trainingData: DataFrame = [
    "bill_length_mm": billLength,
    "bill_depth_mm": billDepth,
    "body_mass_g": bodyMass
]

let model = try MLBoostedTreeRegressor(
    trainingData: trainingData,
    targetColumn: "body_mass_g",
    featureColumns: ["bill_length_mm", "bill_depth_mm"]
)
```

For PostgreSQL, SQLite, or MySQL, choose a Swift driver that matches the
application and decode each selected SQL column into a consistent Swift type.
Keep null handling explicit: filter incomplete rows, substitute a justified
value, or choose an algorithm that handles missing values appropriately.

The classification and regression examples in this folder start from CSV only
to keep setup simple. Once a query has produced the same `DataFrame`, the model
training code is unchanged.
