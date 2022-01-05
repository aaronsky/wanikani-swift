import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SpacedRepetitionSystem {
    init() {
        self.init(
            burningStagePosition: 8,
            created: Date(timeIntervalSince1970: 1000),
            description: "ground",
            id: 0,
            name: "ground",
            passingStagePosition: 1,
            stages: [
                Stage(
                    interval: 0,
                    intervalUnit: "seconds",
                    position: 0
                )
            ],
            startingStagePosition: 0,
            unlockingStagePosition: 0,
            url: URL()
        )
    }
}

class SpacedRepetitionSystemsTests: XCTestCase {
    func testSpacedRepetitionSystemList() async throws {
        let expected = ModelCollection(data: [SRS()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.spacedRepetitionSystems())
        XCTAssertEqual(response.data, expected)
    }

    func testSpacedRepetitionSystemGet() async throws {
        let expected = SRS()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.spacedRepetitionSystem(0))
        XCTAssertEqual(response.data, expected)
    }
}
