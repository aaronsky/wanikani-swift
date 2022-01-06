import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension VoiceActor {
    init() {
        self.init(
            description: "Someone who has friends.",
            gender: "female",
            id: 0,
            name: "Haruko",
            url: URL()
        )
    }
}

class VoiceActorsTests: XCTestCase {
    func testVoiceActorList() async throws {
        let expected = ModelCollection(data: [VoiceActor()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.voiceActors(ids: [0, 1], updatedAfter: .testing))
        XCTAssertEqual(response.data, expected)
    }

    func testVoiceActorGet() async throws {
        let expected = VoiceActor()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.voiceActor(0))
        XCTAssertEqual(response.data, expected)
    }
}
