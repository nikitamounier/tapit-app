import Dispatch

extension DispatchTime {
    static func - (lhs: DispatchTime, rhs: DispatchTime) -> DispatchTimeInterval {
        return lhs.distance(to: rhs)
    }
}

extension DispatchTimeInterval {
    static func > (lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
        switch lhs {
        case .never:
            return false
            
        case let .seconds(x):
            switch rhs {
            case let .seconds(y):
                return x > y
            case let .milliseconds(y):
                return x > y / 1_000
            case let .microseconds(y):
                return x > y / 1_000_000
            case let .nanoseconds(y):
                return x > y / 1_000_000_000
            case .never:
                return true
            @unknown default:
                fatalError()
            }
            
        case let .milliseconds(x):
            switch rhs {
            case let .seconds(y):
                return x > y * 1_000
            case let .milliseconds(y):
                return x > y
            case let .microseconds(y):
                return x > y / 1_000
            case let .nanoseconds(y):
                return x > y / 1_000_000
            case .never:
                return true
            @unknown default:
                fatalError()
            }
            
        case let .microseconds(x):
            switch rhs {
            case let .seconds(y):
                return x > y * 1_000_000
            case let .milliseconds(y):
                return x > y * 1_000
            case let .microseconds(y):
                return x > y
            case let .nanoseconds(y):
                return x > y / 1_000
            case .never:
                return true
            @unknown default:
               fatalError()
            }
            
        case let .nanoseconds(x):
            switch rhs {
            case let .seconds(y):
                return x > y * 1_000_000_000
            case let .milliseconds(y):
                return x > y * 1_000_000
            case let .microseconds(y):
                return x > y * 1_000
            case let .nanoseconds(y):
                return x > y
            case .never:
                return true
            @unknown default:
                fatalError()
            }
            
        @unknown default:
            fatalError()
        }
    }
}
