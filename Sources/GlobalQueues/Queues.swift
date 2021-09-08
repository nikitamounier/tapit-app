import class Dispatch.DispatchQueue

public enum GlobalQueues {
    public static let p2pBrowserQueue = DispatchQueue(label: "p2p.browser")
    
    public static let p2pListenerQueue = DispatchQueue(label: "p2p.listener")
    
    public static var p2pConnectionQueue: () -> DispatchQueue {
        var increment = 0
        return {
            defer { increment += 1 }
            return DispatchQueue(label: "p2p.connection-\(increment)")
        }
    }
}
