import Foundation

/// Level progressions contain information about a user's progress through the WaniKani levels.
///
/// A level progression is created when a user has met the prerequisites for leveling up, which are:
/// - Reach a 90% passing rate on assignments for a user's current level with a ``Assignment/subjectType`` of ``Subject/Kind/kanji``.
/// - Have access to the level. Under ``Users``, the ``User/level`` must be less than or equal to ``User/Subscription-swift.struct/maxLevelGranted``.
public struct LevelProgression: ModelProtocol {
    public let object = "level_progression"

    /// Timestamp when the user abandons the level. This is primary used when the user initiates a reset.
    public var abandoned: Date?
    /// Timestamp when the user burns 100% of the assignments belonging to the associated subject's level.
    public var completed: Date?
    /// Timestamp when the level progression is created.
    public var created: Date
    public var id: Int
    public var lastUpdated: Date?
    /// The level of the progression, with possible values from `1` to `60`.
    public var level: Int
    /// Timestamp when the user passes at least 90% of the assignments with a type of `kanji` belonging to the associated subject's level.
    public var passed: Date?
    /// Timestamp when the user starts their first lesson of a subject belonging to the level.
    public var started: Date?
    /// Timestamp when the user can access lessons and reviews for the `level`.
    public var unlocked: Date?
    public var url: URL

    public init(
        abandoned: Date? = nil,
        completed: Date? = nil,
        created: Date,
        id: Int,
        lastUpdated: Date? = nil,
        level: Int,
        passed: Date? = nil,
        started: Date? = nil,
        unlocked: Date? = nil,
        url: URL
    ) {
        self.abandoned = abandoned
        self.completed = completed
        self.created = created
        self.id = id
        self.lastUpdated = lastUpdated
        self.level = level
        self.passed = passed
        self.started = started
        self.unlocked = unlocked
        self.url = url
    }

    public init(
        from decoder: Decoder
    ) throws {
        let modelContainer = try decoder.container(keyedBy: ModelCodingKeys.self)

        let object = try modelContainer.decode(String.self, forKey: .object)
        guard object == self.object else {
            throw DecodingError.typeMismatch(
                Self.self,
                DecodingError.Context(
                    codingPath: decoder.codingPath,
                    debugDescription: "Expected to decode \(self.object) but found object with resource type \(object)"
                )
            )
        }

        id = try modelContainer.decode(Int.self, forKey: .id)
        lastUpdated = try modelContainer.decodeIfPresent(Date.self, forKey: .lastUpdated)
        url = try modelContainer.decode(URL.self, forKey: .url)

        let container = try modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)

        abandoned = try container.decodeIfPresent(Date.self, forKey: .abandoned)
        completed = try container.decodeIfPresent(Date.self, forKey: .completed)
        created = try container.decode(Date.self, forKey: .created)
        level = try container.decode(Int.self, forKey: .level)
        passed = try container.decodeIfPresent(Date.self, forKey: .passed)
        started = try container.decodeIfPresent(Date.self, forKey: .started)
        unlocked = try container.decodeIfPresent(Date.self, forKey: .unlocked)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(abandoned, forKey: .abandoned)
        try container.encode(completed, forKey: .completed)
        try container.encode(created, forKey: .created)
        try container.encode(level, forKey: .level)
        try container.encode(passed, forKey: .passed)
        try container.encode(started, forKey: .started)
        try container.encode(unlocked, forKey: .unlocked)
    }

    private enum CodingKeys: String, CodingKey {
        case abandoned = "abandoned_at"
        case completed = "completed_at"
        case created = "created_at"
        case level
        case passed = "passed_at"
        case started = "started_at"
        case unlocked = "unlocked_at"
    }
}
