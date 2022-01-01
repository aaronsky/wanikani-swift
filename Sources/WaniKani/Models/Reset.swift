import Foundation

/// Users can reset their progress back to any level at or below their current level. When they reset to a particular level, all of the ``Assignment``s and ``ReviewStatistic``s at that level or higher are set back to their default state.
///
/// Resets contain information about when those resets happen, the starting level, and the target level.
public struct Reset: ModelProtocol {
    public let object = "reset"

    /// Timestamp when the user confirmed the reset.
    public var confirmed: Date?
    /// Timestamp when the reset was created.
    public var created: Date
    public var id: Int
    public var lastUpdated: Date?
    /// The user's level before the reset, from `1` to `60`.
    public var originalLevel: Int
    /// The user's level after the reset, from `1` to `60`. It must be less than or equal to ``originalLevel``.
    public var targetLevel: Int
    public var url: URL

    init(
        confirmed: Date? = nil,
        created: Date,
        id: Int,
        lastUpdated: Date? = nil,
        originalLevel: Int,
        targetLevel: Int,
        url: URL
    ) {
        self.confirmed = confirmed
        self.created = created
        self.id = id
        self.lastUpdated = lastUpdated
        self.originalLevel = originalLevel
        self.targetLevel = targetLevel
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

        confirmed = try container.decodeIfPresent(Date.self, forKey: .confirmed)
        created = try container.decode(Date.self, forKey: .created)
        originalLevel = try container.decode(Int.self, forKey: .originalLevel)
        targetLevel = try container.decode(Int.self, forKey: .targetLevel)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(confirmed, forKey: .confirmed)
        try container.encode(created, forKey: .created)
        try container.encode(originalLevel, forKey: .originalLevel)
        try container.encode(targetLevel, forKey: .targetLevel)
    }

    private enum CodingKeys: String, CodingKey {
        case confirmed = "confirmed_at"
        case created = "created_at"
        case originalLevel = "original_level"
        case targetLevel = "target_level"
    }
}
