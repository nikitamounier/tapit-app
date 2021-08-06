import ComposableArchitecture
import GeneralMocks
import NonEmpty
import Optics
import Prelude
import SharedModels
import XCTest

@testable import HistoryFeature

class HistoryFeatureTests: XCTestCase {
    let firstProfile = SentProfile(
        profile: UserProfile(
            id: .deadbeef,
            name: "Johnny Appleseed",
            profileImage: .mock,
            socials: [
                .mockInstagram(name: "johnnyappleseed"),
                .mockReddit(name: "johnnyappleseed"),
                .mockGithub(name: "johnnyappleseed"),
                .mockTwitter(name: "johnapleseed"),
                .mockSnapchat(name: "johnnyappleseed")
            ]
        ),
        sendDate: .oneDayAgo,
        expirationInterval: nil
    )
    
    let secondProfile = SentProfile(
        profile: UserProfile(
            id: .deadbeef1,
            name: "Jane Doe",
            profileImage: .mock,
            socials: [
                .mockLinkedIn(name: "janedoe"),
                .mockEmail(name: "janedoe@gmail.com"),
                .mockFacebook(name: "janedoe"),
            ]
        ),
        sendDate: .oneWeekAgo,
        expirationInterval: 10 |> Days.init
    )
    
    let thirdProfile = SentProfile(
        profile: UserProfile(
            id: .deadbeef2,
            name: "John Doe",
            profileImage: .mock,
            socials: [
                .mockPhone(),
                .mockWeChat(name: "johndoe"),
                .mockTikTok(name: "johndoe"),
                .mockGithub(name: "johndoe"),
                .mockReddit(name: "johndoe"),
                .mockTwitter(name: "johndoe")
            ]
        ),
        sendDate: .oneMonthAgo,
        expirationInterval: nil
    )
    

    func testNavigation() {

        let store = TestStore(
            initialState: HistoryState(profiles: [firstProfile, secondProfile, thirdProfile]),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: .failing,
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.setNavigation(id: firstProfile.id)) {
            $0.selectedProfile = .deadbeef
        }

        store.send(.setNavigation(id: nil)) {
            $0.selectedProfile = nil
        }

        store.send(.setNavigation(id: thirdProfile.id)) {
            $0.selectedProfile = .deadbeef2
        }

        store.send(.setNavigation(id: secondProfile.id)) {
            $0.selectedProfile = .deadbeef1
        }

        store.send(.setNavigation(id: nil)) {
            $0.selectedProfile = nil
        }
    }

    func testSentProfileActions() {

        let golfCategory: ProfilesCategory = .custom(
            name: "Golf",
            profileIDs: [firstProfile.id, thirdProfile.id]
        )

        let store = TestStore(
            initialState: HistoryState(
                profiles: [firstProfile, secondProfile, thirdProfile],
                categories: .init(arrayLiteral: .all, golfCategory)
            ),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: .failing,
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.sentProfile(id: secondProfile.id, action: .removeSentProfile)) {
            $0.profiles = [self.firstProfile, self.thirdProfile]
        }

        store.send(.sentProfile(id: firstProfile.id, action: .removeFromCategory(golfCategory))) {
            $0.categories = .init(arrayLiteral:
                .all,
                .custom(name: "Golf", profileIDs: [self.thirdProfile.id])
            )
        }

        store.send(.sentProfile(id: firstProfile.id, action: .addToCategory(golfCategory))) {
            $0.categories = .init(arrayLiteral:
                .all,
                .custom(name: "Golf", profileIDs: [self.firstProfile.id, self.thirdProfile.id])
            )
        }
    }

    func testCategoryActions() {

        let golfCategory: ProfilesCategory = .custom(
            name: "Golf",
            profileIDs: [firstProfile.id, thirdProfile.id]
        )

        let girlCategory: ProfilesCategory = .custom(
            name: "Girl friends",
            profileIDs: [secondProfile.id]
        )

        let store = TestStore(
            initialState: HistoryState(
                profiles: [firstProfile, secondProfile, thirdProfile],
                categories: .init(arrayLiteral: .all, golfCategory)
            ),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: .failing,
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.createCategoryButtonTapped) {
            $0.showCategoryCreation = true
        }

        store.send(.removeCategoryCreation) {
            $0.showCategoryCreation = false
        }

        store.send(.createCategory(name: "Girl friends", profileIDs: [secondProfile.id])) {
            $0.categories = .init(arrayLiteral: .all, golfCategory, girlCategory)
        }

        store.send(.moveCategory(from: 1, toOffset: 3)) {
            $0.categories = .init(arrayLiteral: .all, girlCategory, golfCategory)
        }

        store.send(.moveCategory(from: 0, toOffset: 2)) // shouldn't do anything since .all can't be moved

        store.send(.moveCategory(from: 1, toOffset: 0)) // shouldn't do anything since .all can't be moved

        store.send(.removeCategory(index: 2)) {
            $0.categories = .init(arrayLiteral: .all, girlCategory)
        }

        store.send(.removeCategory(index: 0)) // shouldn't do anything since .all can't be removed
    }

    func testChangingViewingOrder() {
        let store = TestStore(
            initialState: HistoryState(profiles: [firstProfile, secondProfile, thirdProfile]),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: .failing,
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.changeViewingOrder(to: .newestToOldest)) // already .newestToOldest

        store.send(.changeViewingOrder(to: .oldestToNewest)) {
            $0.viewingOrder = .oldestToNewest
        }

        store.send(.changeViewingOrder(to: .alphabetical)) {
            $0.viewingOrder = .alphabetical
        }
    }

    func testSimpleSearching() {
        let store = TestStore(
            initialState: HistoryState(profiles: [firstProfile, secondProfile, thirdProfile]),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: .immediate,
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.searchBarTapped) {
            $0.isSearching = true
        }

        store.send(.searchInput(text: "Johnny")) {
            $0.currentSearch = "Johnny"
        }

        store.receive(.searchResponse(input: "Johnny")) {
            $0.searchResults = [self.firstProfile.id]
        }

        store.send(.searchInput(text: "")) {
            $0.currentSearch = ""
        }

        store.receive(.searchResponse(input: "")) {
            $0.searchResults = []
        }

        store.send(.searchInput(text: "John")) {
            $0.currentSearch = "John"
        }

        store.receive(.searchResponse(input: "John")) {
            $0.searchResults = [self.firstProfile.id, self.thirdProfile.id]
        }

        store.send(.cancelSearchTapped) {
            $0.currentSearch = ""
            $0.searchResults = []
            $0.isSearching = false
        }
    }

    func testSearchDebounce() {
        let scheduler = DispatchQueue.test

        let store = TestStore(
            initialState: HistoryState(profiles: [firstProfile, secondProfile, thirdProfile]),
            reducer: historyReducer,
            environment: HistoryEnvironment(
                mainQueue: scheduler.eraseToAnyScheduler(),
                feedbackGenerator: .failing,
                isSentProfileExpired: .failing,
                openSocial: .failing,
                openAppSettings: { XCTFail() }
            )
        )

        store.send(.searchBarTapped) {
            $0.isSearching = true
        }

        store.send(.searchInput(text: "J")) {
            $0.currentSearch = "J"
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "Jo")) {
            $0.currentSearch = "Jo"
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "Joh")) {
            $0.currentSearch = "Joh"
        }

        scheduler.advance(by: 0.2)


        store.send(.searchInput(text: "John")) {
            $0.currentSearch = "John"
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "John ")) {
            $0.currentSearch = "John "
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "John D")) {
            $0.currentSearch = "John D"
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "John Do")) {
            $0.currentSearch = "John Do"
        }

        scheduler.advance(by: 0.2)

        store.send(.searchInput(text: "John Doe")) {
            $0.currentSearch = "John Doe"
        }

        scheduler.advance(by: 0.5)

        store.receive(.searchResponse(input: "John Doe")) {
            $0.searchResults = [self.thirdProfile.id]
        }

        store.send(.cancelSearchTapped) {
            $0.currentSearch = ""
            $0.searchResults = []
            $0.isSearching = false
        }
    }
}
