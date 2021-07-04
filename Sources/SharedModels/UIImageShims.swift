#if canImport(AppKit)
import AppKit

public typealias UIImage = NSImage

public extension NSImage {
    func pngData() -> Data? {
        let imageRep = NSBitmapImageRep(data: self.tiffRepresentation!)!
        return imageRep.representation(using: .png, properties: [:])
    }
    
    var scale: CGFloat {
        return .zero
    }
    
    convenience init?(data: Data, scale: CGFloat) {
        self.init(data: data)
    }
    
    convenience init?(systemName: String) {
        self.init(systemSymbolName: systemName, accessibilityDescription: nil)
    }
    
    
}
#endif

