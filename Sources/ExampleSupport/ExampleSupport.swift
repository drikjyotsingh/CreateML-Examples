import CreateML
import Foundation
import TabularData

public enum ExampleError: LocalizedError {
  case missingFile(URL)

  public var errorDescription: String? {
    switch self {
    case .missingFile(let url):
      return "Could not find the data file at \(url.path). Pass a different path with --data."
    }
  }
}

private func value(after flag: String) -> String? {
  guard let index = CommandLine.arguments.firstIndex(of: flag) else {
    return nil
  }

  let valueIndex = CommandLine.arguments.index(after: index)
  guard valueIndex < CommandLine.arguments.endIndex else {
    return nil
  }

  return CommandLine.arguments[valueIndex]
}

public func packageRootURL() -> URL {
  URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()
    .deletingLastPathComponent()
    .deletingLastPathComponent()
}

public func dataURL(defaultRelativePath: String) throws -> URL {
  let url: URL

  if let suppliedPath = value(after: "--data") {
    url = URL(fileURLWithPath: suppliedPath)
  } else {
    url = packageRootURL().appendingPathComponent(defaultRelativePath)
  }

  guard FileManager.default.fileExists(atPath: url.path) else {
    throw ExampleError.missingFile(url)
  }

  return url
}

public func modelOutputURL(fileName: String) throws -> URL {
  let directory: URL

  if let suppliedPath = value(after: "--output-dir") {
    directory = URL(fileURLWithPath: suppliedPath, isDirectory: true)
  } else {
    directory = packageRootURL().appendingPathComponent("Models", isDirectory: true)
  }

  try FileManager.default.createDirectory(
    at: directory,
    withIntermediateDirectories: true
  )

  return directory.appendingPathComponent(fileName)
}

public func metadata(description: String, dataset: String) -> MLModelMetadata {
  MLModelMetadata(
    author: "CreateML-Examples",
    shortDescription: description,
    license: "Apache-2.0",
    version: "1.0",
    additional: ["Training dataset": dataset]
  )
}

public func loadCompletePenguins(from url: URL) throws -> DataFrame {
  let data = try DataFrame(
    contentsOfCSVFile: url,
    types: [
      "species": .string,
      "island": .string,
      "bill_length_mm": .double,
      "bill_depth_mm": .double,
      "flipper_length_mm": .integer,
      "body_mass_g": .integer,
      "sex": .string,
      "year": .integer,
    ]
  )

  let requiredColumns = [
    "species",
    "island",
    "bill_length_mm",
    "bill_depth_mm",
    "flipper_length_mm",
    "body_mass_g",
    "sex",
    "year",
  ]

  let completeRows = data.filter { row in
    requiredColumns.allSatisfy { row[$0] != nil }
  }

  return DataFrame(completeRows)
}
