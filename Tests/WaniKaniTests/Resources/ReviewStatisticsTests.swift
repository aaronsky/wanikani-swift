import Foundation
import XCTest
@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension ReviewStatistic {
    init() {
        self.init(
            created: Date(timeIntervalSince1970: 1000),
            id: 0,
            isHidden: false,
            meaningCorrect: 0,
            meaningCurrentStreak: 0,
            meaningIncorrect: 0,
            meaningMaxStreak: 0,
            percentageCorrect: 0,
            readingCorrect: 0,
            readingCurrentStreak: 0,
            readingIncorrect: 0,
            readingMaxStreak: 0,
            subjectID: 0,
            subjectType: .radical,
            url: URL()
        )
    }
}

class ReviewStatisticsTests: XCTestCase {
    func testReviewStatisticList() async throws {
        let expected = ModelCollection(data: [ReviewStatistic()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.reviewStatistics())
        XCTAssertEqual(response.data, expected)
    }

    func testReviewStatisticGet() async throws {
        let expected = ReviewStatistic()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.reviewStatistic(0))
        XCTAssertEqual(response.data, expected)
    }
}
