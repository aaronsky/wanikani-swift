import Foundation
import XCTest

@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Radical {
    init() {
        self.init(
            amalgamationSubjectIDs: [1, 2],
            auxiliaryMeanings: [
                AuxiliaryMeaning(
                    meaning: "ground",
                    type: .allowlist
                )
            ],
            characters: "上",
            characterImages: [
                CharacterImage(
                    url: URL(),
                    metadata: .png(
                        .init(
                            color: "#000000",
                            dimensions: .init(width: 101, height: 101),
                            styleName: "ground"
                        )
                    )
                )
            ],
            created: .testing,
            documentURL: URL(),
            id: 0,
            lessonPosition: 0,
            level: 1,
            meaningMnemonic: "ground",
            meanings: [
                Meaning(
                    meaning: "ground",
                    isPrimary: true,
                    isAcceptedAnswer: true
                )
            ],
            slug: "ground",
            spacedRepetitionSystemID: 0,
            url: URL()
        )
    }
}

extension Kanji {
    init() {
        self.init(
            amalgamationSubjectIDs: [1, 2],
            auxiliaryMeanings: [
                AuxiliaryMeaning(
                    meaning: "ground",
                    type: .allowlist
                )
            ],
            characters: "上",
            componentSubjectIDs: [1, 2, 3],
            created: .testing,
            documentURL: URL(),
            id: 0,
            lessonPosition: 0,
            level: 1,
            meaningHint: "ground",
            meaningMnemonic: "ground",
            meanings: [
                Meaning(
                    meaning: "ground",
                    isPrimary: true,
                    isAcceptedAnswer: true
                )
            ],
            readingHint: "ground",
            readingMnemonic: "ground",
            readings: [
                Reading(
                    reading: "ground",
                    isPrimary: true,
                    isAcceptedAnswer: true,
                    type: .kunyomi
                )
            ],
            slug: "ground",
            spacedRepetitionSystemID: 0,
            visuallySimilarSubjectIDs: [1],
            url: URL()
        )
    }
}

extension Vocabulary {
    init() {
        self.init(
            auxiliaryMeanings: [
                AuxiliaryMeaning(
                    meaning: "ground",
                    type: .allowlist
                )
            ],
            characters: "上",
            componentSubjectIDs: [0, 1],
            contextSentences: [
                ContextSentence(
                    english: "ground",
                    japanese: "上"
                )
            ],
            created: .testing,
            documentURL: URL(),
            id: 0,
            lessonPosition: 0,
            level: 1,
            meaningMnemonic: "ground",
            meanings: [
                Meaning(
                    meaning: "ground",
                    isPrimary: true,
                    isAcceptedAnswer: true
                )
            ],
            partsOfSpeech: ["noun"],
            pronunciationAudios: [
                PronunciationAudio(
                    url: URL(),
                    contentType: "audio/ogg",
                    metadata: PronunciationAudio.Metadata(
                        gender: "female",
                        sourceID: 0,
                        pronunciation: "ground",
                        voiceActorID: 0,
                        voiceActorName: "Haruko",
                        voiceDescription: "Someone who has friends."
                    )
                )
            ],
            readings: [
                Reading(
                    reading: "ground",
                    isPrimary: true,
                    isAcceptedAnswer: true
                )
            ],
            readingMnemonic: "ground",
            slug: "ground",
            spacedRepetitionSystemID: 0,
            url: URL()
        )
    }
}

extension KanaVocabulary {
    init() {
        self.init(
            auxiliaryMeanings: [
                AuxiliaryMeaning(
                    meaning: "Hi",
                    type: .allowlist
                )
            ],
            characters: "こんにちは",
            contextSentences: [
                ContextSentence(
                    english: "Hello",
                    japanese: "こんにちは"
                )
            ],
            created: .testing,
            documentURL: URL(),
            id: 0,
            lessonPosition: 0,
            level: 1,
            meaningMnemonic: "Hello",
            meanings: [
                Meaning(
                    meaning: "Hello",
                    isPrimary: true,
                    isAcceptedAnswer: true
                )
            ],
            partsOfSpeech: ["expression"],
            pronunciationAudios: [
                PronunciationAudio(
                    url: URL(),
                    contentType: "audio/ogg",
                    metadata: PronunciationAudio.Metadata(
                        gender: "female",
                        sourceID: 0,
                        pronunciation: "ground",
                        voiceActorID: 0,
                        voiceActorName: "Haruko",
                        voiceDescription: "Someone who has friends."
                    )
                )
            ],
            slug: "Hello", spacedRepetitionSystemID: 0, url: URL()
        )
    }
}

class SubjectsTests: XCTestCase {
    func testSubjectList() async throws {
        let expected = ModelCollection(data: [
            Subject.radical(Radical()),
            Subject.kanji(Kanji()),
            Subject.vocabulary(Vocabulary()),
        ])
        let context = try MockContext(content: expected)
        
        let response = try await context.client.send(
            .subjects(
                ids: [0, 1],
                types: [.radical],
                slugs: ["ground"],
                levels: [1, 2],
                isHidden: false,
                updatedAfter: .testing
            )
        )
        XCTAssertEqual(response.data, expected)
    }
    
    func testSubjectGetRadical() async throws {
        let expected: Subject = .radical(Radical())
        let context = try MockContext(content: expected)
        
        let response = try await context.client.send(.subject(0))
        XCTAssertEqual(response.data, expected)
    }
    
    func testSubjectGetKanji() async throws {
        let expected: Subject = .kanji(Kanji())
        let context = try MockContext(content: expected)
        
        let response = try await context.client.send(.subject(0))
        XCTAssertEqual(response.data, expected)
    }
    
    func testSubjectGetVocabulary() async throws {
        let expected: Subject = .vocabulary(Vocabulary())
        let context = try MockContext(content: expected)
        
        let response = try await context.client.send(.subject(0))
        XCTAssertEqual(response.data, expected)
    }
    
    func testSubjectGetKanaVocabulary() async throws {
        let expected: Subject = .kanaVocabulary(KanaVocabulary())
        let context = try MockContext(content: expected)
        
        let response = try await context.client.send(.subject(0))
        XCTAssertEqual(response.data, expected)
    }
}
