import Foundation

public extension Date {
  static var now: Date {
    return Date()
  }
  
  static let oneHourAgo = Date(timeIntervalSinceNow: -3600)
  static let oneDayAgo = Date(timeIntervalSinceNow: -86400)
  static let oneWeekAgo = Date(timeIntervalSinceNow: -604800)
  static let oneMonthAgo = Date(timeIntervalSinceNow: -2629746)
}
