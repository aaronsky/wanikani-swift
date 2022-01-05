import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Summary {
    init() {
        self.init(
            lessons: [
                Summary.Lesson(
                    available: Date(timeIntervalSince1970: 1000),
                    subjectIDs: [1, 2]
                )
            ],
            nextReviews: nil,
            reviews: [
                Summary.Review(
                    available: Date(timeIntervalSince1970: 1000),
                    subjectIDs: [1, 2]
                )
            ],
            url: URL()
        )
    }
}

class SummariesTests: XCTestCase {
    func testSummaryGet() async throws {
        let expected = Summary()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.summary)
        XCTAssertEqual(response.data, expected)
    }
}
