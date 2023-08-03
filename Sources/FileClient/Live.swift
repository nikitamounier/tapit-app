import ComposableArchitecture
import Foundation

extension FileClient {
  private static let documentDirectory = FileManager.default
    .urls(for: .documentDirectory, in: .userDomainMask)
    .first!
  
  public static let liveValue = Self(
    load: { fileName in
      try Data(
        contentsOf: documentDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
      )
    },
    save: { fileName, data in
      try data.write(
        to: documentDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
      )
    },
    delete: { fileName in
      try FileManager.default.removeItem(
        at: documentDirectory.appendingPathComponent(fileName).appendingPathExtension("json")
      )
    }
  )
}
