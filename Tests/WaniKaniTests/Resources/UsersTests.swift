import Foundation
import XCTest
@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension User {
    init() {
        self.init(id: 0,
                  level: 1,
                  preferences: Preferences(autoplayLessonsAudio: false,
                                           autoplayReviewsAudio: false,
                                           defaultVoiceActorID: 0,
                                           displayReviewsSRSIndicator: true,
                                           lessonsBatchSize: 10,
                                           lessonsPresentationOrder: .ascendingLevelThenSubject),
                  profileURL: URL(),
                  started: Date(timeIntervalSince1970: 1000),
                  subscription: Subscription(isActive: true,
                                             maxLevelGranted: 60,
                                             periodEnds: nil,
                                             type: .lifetime),
                  username: "haruko",
                  url: URL())
    }
}

class UsersTests: XCTestCase {
    func testUserMe() async throws {
        let expected = User()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.me)
        XCTAssertEqual(response.data, expected)
    }

    func testUserUpdate() async throws {
        let expected = User()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.updateUser())
        XCTAssertEqual(response.data, expected)
    }
}
