import Foundation

/// Reviews log all the correct and incorrect answers provided through the 'Reviews' section of WaniKani. Review records are created when a user answers all the parts of a subject correctly once; some subjects have both meaning or reading parts, and some only have one or the other. Note that reviews are not created for the quizzes in lessons.
public struct Review: ModelProtocol {
    public let object = "review"

    /// Unique identifier of the associated assignment.
    public var assignmentID: Int
    /// Timestamp when the review was created.
    public var created: Date
    /// The SRS stage interval calculated from the number of correct and incorrect answers, with valid values ranging from `1` to `9`.
    public var endingSRSStage: Int
    public var id: Int
    /// The number of times the user has answered the meaning incorrectly.
    public var incorrectMeaningAnswers: Int
    /// The number of times the user has answered the reading incorrectly.
    public var incorrectReadingAnswers: Int
    public var lastUpdated: Date?
    /// Unique identifier of the associated ``SpacedRepetitionSystem``.
    public var spacedRepetitionSystemID: Int
    /// The starting SRS stage interval, with valid values ranging from `1` to `8`.
    public var startingSRSStage: Int
    /// Unique identifier of the associated subject.
    public var subjectID: Int
    public var url: URL

    public init(
        assignmentID: Int,
        created: Date,
        endingSRSStage: Int,
        id: Int,
        incorrectMeaningAnswers: Int,
        incorrectReadingAnswers: Int,
        lastUpdated: Date? = nil,
        spacedRepetitionSystemID: Int,
        startingSRSStage: Int,
        subjectID: Int,
        url: URL
    ) {
        self.assignmentID = assignmentID
        self.created = created
        self.endingSRSStage = endingSRSStage
        self.id = id
        self.incorrectMeaningAnswers = incorrectMeaningAnswers
        self.incorrectReadingAnswers = incorrectReadingAnswers
        self.lastUpdated = lastUpdated
        self.spacedRepetitionSystemID = spacedRepetitionSystemID
        self.startingSRSStage = startingSRSStage
        self.subjectID = subjectID
        self.url = url
    }

    public init(from decoder: Decoder) throws {
        let modelContainer = try decoder.container(keyedBy: ModelCodingKeys.self)

        let object = try modelContainer.decode(String.self, forKey: .object)
        guard object == self.object else {
            throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                              debugDescription: "Expected to decode \(self.object) but found object with resource type \(object)"))
        }

        id = try modelContainer.decode(Int.self, forKey: .id)
        lastUpdated = try modelContainer.decodeIfPresent(Date.self, forKey: .lastUpdated)
        url = try modelContainer.decode(URL.self, forKey: .url)

        let container = try modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)

        assignmentID = try container.decode(Int.self, forKey: .assignmentID)
        created = try container.decode(Date.self, forKey: .created)
        endingSRSStage = try container.decode(Int.self, forKey: .endingSRSStage)
        incorrectMeaningAnswers = try container.decode(Int.self, forKey: .incorrectMeaningAnswers)
        incorrectReadingAnswers = try container.decode(Int.self, forKey: .incorrectReadingAnswers)
        spacedRepetitionSystemID = try container.decode(Int.self, forKey: .spacedRepetitionSystemID)
        startingSRSStage = try container.decode(Int.self, forKey: .startingSRSStage)
        subjectID = try container.decode(Int.self, forKey: .subjectID)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(assignmentID, forKey: .assignmentID)
        try container.encode(created, forKey: .created)
        try container.encode(endingSRSStage, forKey: .endingSRSStage)
        try container.encode(incorrectMeaningAnswers, forKey: .incorrectMeaningAnswers)
        try container.encode(incorrectReadingAnswers, forKey: .incorrectReadingAnswers)
        try container.encode(spacedRepetitionSystemID, forKey: .spacedRepetitionSystemID)
        try container.encode(startingSRSStage, forKey: .startingSRSStage)
        try container.encode(subjectID, forKey: .subjectID)
    }

    private enum CodingKeys: String, CodingKey {
        case assignmentID = "assignment_id"
        case created = "created_at"
        case endingSRSStage = "ending_srs_stage"
        case incorrectMeaningAnswers = "incorrect_meaning_answers"
        case incorrectReadingAnswers = "incorrect_reading_answers"
        case spacedRepetitionSystemID = "spaced_repetition_system_id"
        case startingSRSStage = "starting_srs_stage"
        case subjectID = "subject_id"
    }
}
