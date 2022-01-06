import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension StudyMaterial {
    init() {
        self.init(
            created: .testing,
            id: 0,
            isHidden: false,
            meaningNote: "the thing beneath your feet",
            meaningSynonyms: ["earth", "land", "dirt floor"],
            readingNote: "the ground is the ground",
            subjectID: 0,
            subjectType: .radical,
            url: URL()
        )
    }
}

class StudyMaterialsTests: XCTestCase {
    func testStudyMaterialList() async throws {
        let expected = ModelCollection(data: [StudyMaterial()])
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .studyMaterials(
                isHidden: false,
                ids: [0, 1],
                subjectIDs: [0, 1],
                subjectTypes: [.radical],
                updatedAfter: .testing
            )
        )
        XCTAssertEqual(response.data, expected)
    }

    func testStudyMaterialGet() async throws {
        let expected = StudyMaterial()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(.studyMaterial(0))
        XCTAssertEqual(response.data, expected)
    }

    func testStudyMaterialCreate() async throws {
        let expected = StudyMaterial()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .createStudyMaterial(
                subjectID: 0,
                meaningNote: "ground",
                readingNote: "ground",
                meaningSynonyms: ["earth", "floor"]
            )
        )
        XCTAssertEqual(response.data, expected)
    }

    func testStudyMaterialUpdate() async throws {
        let expected = StudyMaterial()
        let context = try MockContext(content: expected)

        let response = try await context.client.send(
            .updateStudyMaterial(
                0,
                meaningNote: "ground",
                readingNote: "ground",
                meaningSynonyms: ["earth", "floor"]
            )
        )
        XCTAssertEqual(response.data, expected)
    }
}
