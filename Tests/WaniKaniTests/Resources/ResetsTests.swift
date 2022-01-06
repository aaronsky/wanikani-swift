import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Reset {
    init() {
        self.init(
            confirmed: nil,
            created: .testing,
            id: 0,
            originalLevel: 0,
            targetLevel: 0,
            url: URL()
        )
    }
}

class ResetsTests: XCTestCase {
    func testResetList() async throws {
        let expected = ModelCollection(data: [Reset()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.resets(ids: [0, 1], updatedAfter: .testing))
        XCTAssertEqual(response.data, expected)
    }

    func testResetGet() async throws {
        let expected = Reset()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.reset(0))
        XCTAssertEqual(response.data, expected)
    }
}
