import ComposableArchitecture
import Foundation

extension FileClient {
  private static let documentDirectory = FileManager.default
    .urls(for: .documentDirectory, in: .userDomainMask)
    .first!
  
  public static let live = Self(
    load: { fileName in
        .catching {
          try Data(
            contentsOf: documentDirectory
              .appendingPathComponent(fileName)
              .appendingPathExtension("json")
          )
        }
    },
    save: { fileName, data in
        .fireAndForget {
          _ = try? data.write(
            to: documentDirectory
              .appendingPathExtension(fileName)
              .appendingPathExtension("json")
          )
        }
    },
    delete: { fileName in
        .fireAndForget {
          try? FileManager.default.removeItem(
            at: documentDirectory
              .appendingPathComponent(fileName)
              .appendingPathExtension("json")
          )
        }
    }
  )
}
