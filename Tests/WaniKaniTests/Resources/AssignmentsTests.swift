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
            created: Date(timeIntervalSince1970: 1000),
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

        let response = try await context.client.send(.assignments())
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

        let response = try await context.client.send(.startAssignment(0))
        XCTAssertEqual(response.data, expected)
    }
}
