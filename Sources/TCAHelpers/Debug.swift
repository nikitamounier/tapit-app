import ComposableArchitecture
import Difference
import Foundation

public extension Reducer {
    func debugDiff(
        _ prefix: String = "",
        actionFormat: ActionFormat = .prettyPrint,
        environment toDebugEnvironment: @escaping (Environment) -> DebugEnvironment = { _ in
            DebugEnvironment()
        }
    ) -> Reducer {
        self.debugDiff(
            prefix,
            state: { $0 },
            action: .self,
            actionFormat: actionFormat,
            environment: toDebugEnvironment
        )
    }
    
    func debugDiffActions(
        _ prefix: String = "",
        actionFormat: ActionFormat = .prettyPrint,
        environment toDebugEnvironment: @escaping (Environment) -> DebugEnvironment = { _ in
          DebugEnvironment()
        }
      ) -> Reducer {
        self.debugDiff(
          prefix,
          state: { _ in () },
          action: .self,
          actionFormat: actionFormat,
          environment: toDebugEnvironment
        )
      }
    
    func debugDiff<LocalState, LocalAction>(
        _ prefix: String = "",
        state toLocalState: @escaping (State) -> LocalState,
        action toLocalAction: CasePath<Action, LocalAction>,
        actionFormat: ActionFormat = .prettyPrint,
        environment toDebugEnvironment: @escaping (Environment) -> DebugEnvironment = { _ in
            DebugEnvironment()
        }
    ) -> Reducer {
#if DEBUG
        
        return .init { state, action, environment in
            let previousState = toLocalState(state)
            let effects = self.run(&state, action, environment)
            guard let localAction = toLocalAction.extract(from: action) else { return effects }
            let nextState = toLocalState(state)
            let debugEnvironment = toDebugEnvironment(environment)
            return .merge(
                .fireAndForget {
                    debugEnvironment.queue.async {
                        let actionOutput =
                        actionFormat == .prettyPrint
                        ? debugOutput(localAction).indent(by: 2)
                        : debugCaseOutput(localAction).indent(by: 2)
                        let stateOutput =
                        LocalState.self == Void.self
                        ? ""
                        : diff(previousState, nextState, indentationType: .pipe, nameLabels: .comparing).joined() ?| "(No state changes)\n"
                        debugEnvironment.printer(
                        """
                        \(prefix.isEmpty ? "" : "\(prefix): ")received action:
                        \(actionOutput)
                        \(stateOutput)
                        """
                        )
                    }
                },
                effects
            )
        }
        
#else
        return self
#endif
    }
}

func debugOutput(_ value: Any, indent: Int = 0) -> String {
    var visitedItems: Set<ObjectIdentifier> = []
    
    func debugOutputHelp(_ value: Any, indent: Int = 0) -> String {
        let mirror = Mirror(reflecting: value)
        switch (value, mirror.displayStyle) {
        case let (value as CustomDebugOutputConvertible, _):
            return value.debugOutput.indent(by: indent)
        case (_, .collection?):
            return """
        [
        \(mirror.children.map { "\(debugOutput($0.value, indent: 2)),\n" }.joined())]
        """
                .indent(by: indent)
            
        case (_, .dictionary?):
            let pairs = mirror.children.map { label, value -> String in
                let pair = value as! (key: AnyHashable, value: Any)
                return "\("\(debugOutputHelp(pair.key.base)): \(debugOutputHelp(pair.value)),".indent(by: 2))\n"
            }
            return """
        [
        \(pairs.sorted().joined())]
        """
                .indent(by: indent)
            
        case (_, .set?):
            return """
        Set([
        \(mirror.children.map { "\(debugOutputHelp($0.value, indent: 2)),\n" }.sorted().joined())])
        """
                .indent(by: indent)
            
        case (_, .optional?):
            return mirror.children.isEmpty
            ? "nil".indent(by: indent)
            : debugOutputHelp(mirror.children.first!.value, indent: indent)
            
        case (_, .enum?) where !mirror.children.isEmpty:
            let child = mirror.children.first!
            let childMirror = Mirror(reflecting: child.value)
            let elements =
            childMirror.displayStyle != .tuple
            ? debugOutputHelp(child.value, indent: 2)
            : childMirror.children.map { child -> String in
                let label = child.label!
                return "\(label.hasPrefix(".") ? "" : "\(label): ")\(debugOutputHelp(child.value))"
            }
            .joined(separator: ",\n")
            .indent(by: 2)
            return """
        \(mirror.subjectType).\(child.label!)(
        \(elements)
        )
        """
                .indent(by: indent)
            
        case (_, .enum?):
            return """
        \(mirror.subjectType).\(value)
        """
                .indent(by: indent)
            
        case (_, .struct?) where !mirror.children.isEmpty:
            let elements = mirror.children
                .map { "\($0.label.map { "\($0): " } ?? "")\(debugOutputHelp($0.value))".indent(by: 2) }
                .joined(separator: ",\n")
            return """
        \(mirror.subjectType)(
        \(elements)
        )
        """
                .indent(by: indent)
            
        case let (value as AnyObject, .class?)
            where !mirror.children.isEmpty && !visitedItems.contains(ObjectIdentifier(value)):
            visitedItems.insert(ObjectIdentifier(value))
            let elements = mirror.children
                .map { "\($0.label.map { "\($0): " } ?? "")\(debugOutputHelp($0.value))".indent(by: 2) }
                .joined(separator: ",\n")
            return """
        \(mirror.subjectType)(
        \(elements)
        )
        """
                .indent(by: indent)
            
        case let (value as AnyObject, .class?)
            where !mirror.children.isEmpty && visitedItems.contains(ObjectIdentifier(value)):
            return "\(mirror.subjectType)(↩︎)"
            
        case let (value as CustomStringConvertible, .class?):
            return value.description
                .replacingOccurrences(
                    of: #"^<([^:]+): 0x[^>]+>$"#, with: "$1()", options: .regularExpression
                )
                .indent(by: indent)
            
        case let (value as CustomDebugStringConvertible, _):
            return value.debugDescription
                .replacingOccurrences(
                    of: #"^<([^:]+): 0x[^>]+>$"#, with: "$1()", options: .regularExpression
                )
                .indent(by: indent)
            
        case let (value as CustomStringConvertible, _):
            return value.description
                .indent(by: indent)
            
        case (_, .struct?), (_, .class?):
            return "\(mirror.subjectType)()"
                .indent(by: indent)
            
        case (_, .tuple?) where mirror.children.isEmpty:
            return "()"
                .indent(by: indent)
            
        case (_, .tuple?):
            let elements = mirror.children.map { child -> String in
                let label = child.label!
                return "\(label.hasPrefix(".") ? "" : "\(label): ")\(debugOutputHelp(child.value))"
                    .indent(by: 2)
            }
            return """
        (
        \(elements.joined(separator: ",\n"))
        )
        """
                .indent(by: indent)
            
        case (_, nil):
            return "\(value)"
                .indent(by: indent)
            
        @unknown default:
            return "\(value)"
                .indent(by: indent)
        }
    }
    
    return debugOutputHelp(value, indent: indent)
}

extension String {
    func indent(by indent: Int) -> String {
        let indentation = String(repeating: " ", count: indent)
        return indentation + self.replacingOccurrences(of: "\n", with: "\n\(indentation)")
    }
}

public protocol CustomDebugOutputConvertible {
    var debugOutput: String { get }
}

extension Date: CustomDebugOutputConvertible {
    public var debugOutput: String {
        dateFormatter.string(from: self)
    }
}

private let dateFormatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")!
    return formatter
}()

extension URL: CustomDebugOutputConvertible {
    public var debugOutput: String {
        self.absoluteString
    }
}

#if DEBUG
#if canImport(Speech)
import Speech
extension SFSpeechRecognizerAuthorizationStatus: CustomDebugOutputConvertible {
    public var debugOutput: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .denied:
            return "denied"
        case .restricted:
            return "restricted"
        case .authorized:
            return "authorized"
        @unknown default:
            return "unknown"
        }
    }
}
#endif
#endif

func debugCaseOutput(_ value: Any) -> String {
    func debugCaseOutputHelp(_ value: Any) -> String {
        let mirror = Mirror(reflecting: value)
        switch mirror.displayStyle {
        case .enum:
            guard let child = mirror.children.first else {
                let childOutput = "\(value)"
                return childOutput == "\(type(of: value))" ? "" : ".\(childOutput)"
            }
            let childOutput = debugCaseOutputHelp(child.value)
            return ".\(child.label ?? "")\(childOutput.isEmpty ? "" : "(\(childOutput))")"
        case .tuple:
            return mirror.children.map { label, value in
                let childOutput = debugCaseOutputHelp(value)
                return "\(label.map { isUnlabeledArgument($0) ? "_:" : "\($0):" } ?? "")\(childOutput.isEmpty ? "" : " \(childOutput)")"
            }
            .joined(separator: ", ")
        default:
            return ""
        }
    }
    
    return "\(type(of: value))\(debugCaseOutputHelp(value))"
}

private func isUnlabeledArgument(_ label: String) -> Bool {
    label.firstIndex(where: { $0 != "." && !$0.isNumber }) == nil
}

infix operator ?|: NilCoalescingPrecedence

func ?| <A: Collection>(lhs: A, rhs: @autoclosure () -> A) -> A {
    return lhs.isEmpty ? rhs() : lhs
}

