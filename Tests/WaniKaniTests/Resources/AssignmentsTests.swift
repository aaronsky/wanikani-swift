import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Assignment {
    init() {
        self.init(
            available: nil,
            burned: nil,
            created: .testing,
            id: 0,
            isHidden: false,
            lastUpdated: nil,
            level: 0,
            passed: nil,
            resurrected: nil,
            srsStage: 0,
            started: nil,
            subjectID: 0,
            subjectType: .radical,
            unlocked: nil,
            url: URL()
        )
    }
}

class AssignmentsTests: XCTestCase {
    func testAssignmentList() async throws {
        let expected = ModelCollection(data: [Assignment()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .assignments(
                availableAfter: .testing,
                availableBefore: .testing,
                isBurned: false,
                isHidden: false,
                isUnlocked: true,
                ids: [0, 1],
                immediatelyAvailableForLessons: false,
                immediatelyAvailableForReview: true,
                inReview: true,
                levels: [10, 11, 12],
                srsStages: [1, 2],
                isStarted: true,
                subjectIDs: [400, 4000],
                subjectTypes: [.radical, .kanji],
                updatedAfter: .testing
            )
        )
        XCTAssertEqual(response.data, expected)
    }

    func testAssignmentGet() async throws {
        let expected = Assignment()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.assignment(0))
        XCTAssertEqual(response.data, expected)
    }

    func testAssignmentCreate() async throws {
        let expected = Assignment()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.startAssignment(0, startedAt: .testing))
        XCTAssertEqual(response.data, expected)
    }
}
