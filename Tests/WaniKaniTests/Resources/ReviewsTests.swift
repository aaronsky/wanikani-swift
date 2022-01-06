import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Review {
    init() {
        self.init(
            assignmentID: 0,
            created: .testing,
            endingSRSStage: 0,
            id: 0,
            incorrectMeaningAnswers: 0,
            incorrectReadingAnswers: 0,
            spacedRepetitionSystemID: 0,
            startingSRSStage: 0,
            subjectID: 0,
            url: URL()
        )
    }
}

class ReviewsTests: XCTestCase {
    func testReviewList() async throws {
        let expected = ModelCollection(data: [Review()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .reviews(assignmentIDs: [0, 1], ids: [0, 1], subjectIDs: [0, 1], updatedAfter: .testing)
        )
        XCTAssertEqual(response.data, expected)
    }

    func testReviewGet() async throws {
        let expected = Review()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.review(0))
        XCTAssertEqual(response.data, expected)
    }

    func testReviewCreate() async throws {
        let expected = Review()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .createReview(
                assignmentID: 0,
                subjectID: 0,
                incorrectMeaningAnswers: 0,
                incorrectReadingAnswers: 0,
                createdAt: .testing
            )
        )
        XCTAssertEqual(response.data, expected)
    }
}
