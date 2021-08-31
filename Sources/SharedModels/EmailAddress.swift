import Foundation

public struct EmailAddress: RawRepresentable, Codable, Hashable, Equatable {
    public let rawValue: String
    
    public init?(rawValue: String) {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        
        let range = NSRange(rawValue.startIndex..<rawValue.endIndex, in: rawValue)
        
        let matches = detector?.matches(in: rawValue, options: [], range: range)
        
        guard let match = matches?.first, matches?.count == 1 else {
            return nil
        }
        
        guard match.url?.scheme == "mailto", match.range == range else {
            return nil
        }
        
        self.rawValue = rawValue
    }
}
