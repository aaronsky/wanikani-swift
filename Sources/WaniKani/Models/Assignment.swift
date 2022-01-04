import Foundation

/// Assignments contain information about a user's progress on a particular subject, including their current state and timestamps for
/// various progress milestones. Assignments are created when a user has passed all the components of the given subject and the
/// assignment is at or below their current level for the first time.
///
/// The ``unlocked``, ``started``, ``passed``, and ``burned`` timestamps are always in sequential order — assignments
/// can't be started before they're unlocked, passed before they're started, etc.
public struct Assignment: ModelProtocol {
    public let object = "assignment"

    /// Timestamp when the related subject will be available in the user's review queue.
    public var available: Date?
    /// Timestamp when the user reaches SRS stage 9 the first time.
    public var burned: Date?
    /// Timestamp when the assignment was created.
    public var created: Date
    public var id: Int
    /// Indicates if the associated subject has been hidden, preventing it from appearing in lessons or reviews.
    public var isHidden: Bool
    public var lastUpdated: Date?
    /// Level for the given assignment.
    public var level: Int?
    /// Timestamp when the user reaches SRS stage 5 for the first time.
    public var passed: Date?
    /// Timestamp when the subject is resurrected and placed back in the user's review queue.
    public var resurrected: Date?
    /// The current SRS stage interval. The interval range is determined by the related subject's ``SpacedRepetitionSystem``.
    public var srsStage: Int
    /// Timestamp when the user completes the lesson for the related subject.
    public var started: Date?
    /// Unique identifier of the associated subject.
    public var subjectID: Int
    /// The type of the associated subject.
    public var subjectType: Subject.Kind
    /// The timestamp when the related subject has its prerequisites satisfied and is made available in lessons.
    ///
    /// Prerequisites are:
    /// - The subject components have reached SRS stage 5 once (they have been “passed”).
    /// - The user's level is equal to or greater than the level of the assignment’s subject.
    public var unlocked: Date?
    public var url: URL

    public init(
        available: Date? = nil,
        burned: Date? = nil,
        created: Date,
        id: Int,
        isHidden: Bool,
        lastUpdated: Date? = nil,
        level: Int? = nil,
        passed: Date? = nil,
        resurrected: Date? = nil,
        srsStage: Int,
        started: Date? = nil,
        subjectID: Int,
        subjectType: Subject.Kind,
        unlocked: Date? = nil,
        url: URL
    ) {
        self.available = available
        self.burned = burned
        self.created = created
        self.id = id
        self.isHidden = isHidden
        self.lastUpdated = lastUpdated
        self.level = level
        self.passed = passed
        self.resurrected = resurrected
        self.srsStage = srsStage
        self.started = started
        self.subjectID = subjectID
        self.subjectType = subjectType
        self.unlocked = unlocked
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

        available = try container.decodeIfPresent(Date.self, forKey: .available)
        burned = try container.decodeIfPresent(Date.self, forKey: .burned)
        created = try container.decode(Date.self, forKey: .created)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        level = try container.decodeIfPresent(Int.self, forKey: .level)
        passed = try container.decodeIfPresent(Date.self, forKey: .passed)
        resurrected = try container.decodeIfPresent(Date.self, forKey: .resurrected)
        srsStage = try container.decode(Int.self, forKey: .srsStage)
        started = try container.decodeIfPresent(Date.self, forKey: .started)
        subjectID = try container.decode(Int.self, forKey: .subjectID)
        subjectType = try container.decode(Subject.Kind.self, forKey: .subjectType)
        unlocked = try container.decodeIfPresent(Date.self, forKey: .unlocked)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(available, forKey: .available)
        try container.encode(burned, forKey: .burned)
        try container.encode(created, forKey: .created)
        try container.encode(isHidden, forKey: .isHidden)
        try container.encode(level, forKey: .level)
        try container.encode(passed, forKey: .passed)
        try container.encode(resurrected, forKey: .resurrected)
        try container.encode(srsStage, forKey: .srsStage)
        try container.encode(started, forKey: .started)
        try container.encode(subjectID, forKey: .subjectID)
        try container.encode(subjectType, forKey: .subjectType)
        try container.encode(unlocked, forKey: .unlocked)
    }

    private enum CodingKeys: String, CodingKey {
        case available = "available_at"
        case burned = "burned_at"
        case created = "created_at"
        case isHidden = "hidden"
        case level
        case passed = "passed_at"
        case resurrected = "resurrected_at"
        case srsStage = "srs_stage"
        case started = "started_at"
        case subjectID = "subject_id"
        case subjectType = "subject_type"
        case unlocked = "unlocked_at"
    }
}
