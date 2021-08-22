import Network

extension NWListener.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .setup:
            return "setup"
        case .waiting(let error):
            return "waiting, with error \(error.debugDescription)"
        case .ready:
            return "ready"
        case .failed(let error):
            return "failed, with error \(error.debugDescription)"
        case .cancelled:
            return "cancelled"
        @unknown default:
            return "uknown"
        }
    }
}

extension NWBrowser.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .setup:
            return "setup"
        case .ready:
            return "ready"
        case .failed(let error):
            return "failed, with error \(error.debugDescription)"
        case .cancelled:
            return "cancelled"
        case .waiting(let error):
            return "waiting, with error \(error.debugDescription)"
        @unknown default:
            return "uknown"
        }
    }
}

extension NWConnection.State: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .setup:
            return "setup"
        case .waiting(let error):
            return "waiting, with error \(error.debugDescription)"
        case .preparing:
            return "preparing"
        case .ready:
            return "ready"
        case .failed(let error):
            return "failed, with error \(error.debugDescription)"
        case .cancelled:
            return "cancelled"
        @unknown default:
            return "uknown"
        }
    }
}
