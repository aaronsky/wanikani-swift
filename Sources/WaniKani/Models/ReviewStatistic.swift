import Foundation

/// Review statistics summarize the activity recorded in reviews. They contain sum the number of correct and incorrect answers for both meaning and reading. They track current and maximum streaks of correct answers. They store the overall percentage of correct answers versus total answers.
///
/// A review statistic is created when the user has done their first review on the related subject.
public struct ReviewStatistic: ModelProtocol {
    public let object = "review_statistic"

    /// Timestamp when the review statistic was created.
    public var created: Date
    public var id: Int
    /// Indicates if the associated subject has been hidden, preventing it from appearing in lessons or reviews.
    public var isHidden: Bool
    public var lastUpdated: Date?
    /// Total number of correct answers submitted for the meaning of the associated subject.
    public var meaningCorrect: Int
    /// The current, uninterrupted series of correct answers given for the meaning of the associated subject.
    public var meaningCurrentStreak: Int
    /// Total number of incorrect answers submitted for the meaning of the associated subject.
    public var meaningIncorrect: Int
    /// The longest, uninterrupted series of correct answers ever given for the meaning of the associated subject.
    public var meaningMaxStreak: Int
    /// The overall correct answer rate by the user for the subject, including both meaning and reading.
    ///
    /// Percentage correct can be calculated by rounding the result of:
    ///
    /// ```
    /// (meaningCorrect + readingCorrect) / (meaningCorrect + readingCorrect + meaningIncorrect + readingIncorrect)) * 100
    /// ```
    public var percentageCorrect: Int
    /// Total number of correct answers submitted for the reading of the associated subject.
    public var readingCorrect: Int
    /// The current, uninterrupted series of correct answers given for the reading of the associated subject.
    public var readingCurrentStreak: Int
    /// Total number of incorrect answers submitted for the reading of the associated subject.
    public var readingIncorrect: Int
    /// The longest, uninterrupted series of correct answers ever given for the reading of the associated subject.
    public var readingMaxStreak: Int
    /// Unique identifier of the associated subject.
    public var subjectID: Int
    /// The type of the associated subject.
    public var subjectType: Subject.Kind
    public var url: URL

    init(
        created: Date,
        id: Int,
        isHidden: Bool,
        lastUpdated: Date? = nil,
        meaningCorrect: Int,
        meaningCurrentStreak: Int,
        meaningIncorrect: Int,
        meaningMaxStreak: Int,
        percentageCorrect: Int,
        readingCorrect: Int,
        readingCurrentStreak: Int,
        readingIncorrect: Int,
        readingMaxStreak: Int,
        subjectID: Int,
        subjectType: Subject.Kind,
        url: URL
    ) {
        self.created = created
        self.id = id
        self.isHidden = isHidden
        self.lastUpdated = lastUpdated
        self.meaningCorrect = meaningCorrect
        self.meaningCurrentStreak = meaningCurrentStreak
        self.meaningIncorrect = meaningIncorrect
        self.meaningMaxStreak = meaningMaxStreak
        self.percentageCorrect = percentageCorrect
        self.readingCorrect = readingCorrect
        self.readingCurrentStreak = readingCurrentStreak
        self.readingIncorrect = readingIncorrect
        self.readingMaxStreak = readingMaxStreak
        self.subjectID = subjectID
        self.subjectType = subjectType
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

        created = try container.decode(Date.self, forKey: .created)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        meaningCorrect = try container.decode(Int.self, forKey: .meaningCorrect)
        meaningCurrentStreak = try container.decode(Int.self, forKey: .meaningCurrentStreak)
        meaningIncorrect = try container.decode(Int.self, forKey: .meaningIncorrect)
        meaningMaxStreak = try container.decode(Int.self, forKey: .meaningMaxStreak)
        percentageCorrect = try container.decode(Int.self, forKey: .percentageCorrect)
        readingCorrect = try container.decode(Int.self, forKey: .readingCorrect)
        readingCurrentStreak = try container.decode(Int.self, forKey: .readingCurrentStreak)
        readingIncorrect = try container.decode(Int.self, forKey: .readingIncorrect)
        readingMaxStreak = try container.decode(Int.self, forKey: .readingMaxStreak)
        subjectID = try container.decode(Int.self, forKey: .subjectID)
        subjectType = try container.decode(Subject.Kind.self, forKey: .subjectType)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(created, forKey: .created)
        try container.encode(isHidden, forKey: .isHidden)
        try container.encode(meaningCorrect, forKey: .meaningCorrect)
        try container.encode(meaningCurrentStreak, forKey: .meaningCurrentStreak)
        try container.encode(meaningIncorrect, forKey: .meaningIncorrect)
        try container.encode(meaningMaxStreak, forKey: .meaningMaxStreak)
        try container.encode(percentageCorrect, forKey: .percentageCorrect)
        try container.encode(readingCorrect, forKey: .readingCorrect)
        try container.encode(readingCurrentStreak, forKey: .readingCurrentStreak)
        try container.encode(readingIncorrect, forKey: .readingIncorrect)
        try container.encode(readingMaxStreak, forKey: .readingMaxStreak)
        try container.encode(subjectID, forKey: .subjectID)
        try container.encode(subjectType, forKey: .subjectType)
    }

    private enum CodingKeys: String, CodingKey {
        case created = "created_at"
        case isHidden = "hidden"
        case meaningCorrect = "meaning_correct"
        case meaningCurrentStreak = "meaning_current_streak"
        case meaningIncorrect = "meaning_incorrect"
        case meaningMaxStreak = "meaning_max_streak"
        case percentageCorrect = "percentage_correct"
        case readingCorrect = "reading_correct"
        case readingCurrentStreak = "reading_current_streak"
        case readingIncorrect = "reading_incorrect"
        case readingMaxStreak = "reading_max_streak"
        case subjectID = "subject_id"
        case subjectType = "subject_type"
    }
}
