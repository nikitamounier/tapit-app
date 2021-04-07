// Generated using Sourcery 1.3.4 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
import Foundation




enum Refined: AutoTree {
    case none
    case tabAction(TabAction)
enum TabAction {
    case setTab(to: Tab)

}
    case tappedProfilesAction(TappedProfilesAction)
enum TappedProfilesAction {
    case add(TappedProfile)
    case remove(UUID)
    case removeMultiple(Set<UUID>)

}

}
extension Redux {
struct StateTree: Codable, Equatable, AutoTree {
    var tappedProfileState: TappedProfileState = .init()
struct TappedProfileState: Codable, Equatable {
    var profiles: [UUID: TappedProfile] = .init()
    var properties: Properties = .init()
struct Properties: Codable, Equatable {
    var count: Int = .init()
    var favourites: [UUID] = .init()

}

}
    var tabState: TabState = .init()
struct TabState: Equatable {
    var currentTab: Tab = .init()

}

}
}
