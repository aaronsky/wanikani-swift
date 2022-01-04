import Foundation

typealias SRS = SpacedRepetitionSystem

/// Available spaced repetition systems used for calculating changes to ``Assignment/srsStage``, ``Review/startingSRSStage`` and ``Review/endingSRSStage``. Has relationship with ``Subject``s.
///
/// The following position fields align with the timestamps on assignment:
///   - ``passingStagePosition`` => ``Assignment/passed``,
///   - ``unlockingStagePosition`` => ``Assignment/unlocked``
///   - ``startingStagePosition`` => ``Assignment/started``
///   - ``burningStagePosition`` => ``Assignment/burned``
public struct SpacedRepetitionSystem: ModelProtocol {
    public let object = "spaced_repetition_system"

    /// `position` of the burning stage.
    public var burningStagePosition: Int
    /// Timestamp when the ``SpacedRepetitionSystem`` was created.
    public var created: Date
    /// Details about the spaced repetition system.
    public var description: String
    public var id: Int
    public var lastUpdated: Date?
    /// The name of the spaced repetition system
    public var name: String
    /// `position` of the passing stage.
    public var passingStagePosition: Int
    /// A collection of stages.
    public var stages: [Stage]
    /// `position` of the starting stage.
    public var startingStagePosition: Int
    /// `position` of the unlocking stage.
    public var unlockingStagePosition: Int
    public var url: URL

    public init(
        burningStagePosition: Int,
        created: Date,
        description: String,
        id: Int,
        lastUpdated: Date? = nil,
        name: String,
        passingStagePosition: Int,
        stages: [SpacedRepetitionSystem.Stage],
        startingStagePosition: Int,
        unlockingStagePosition: Int,
        url: URL
    ) {
        self.burningStagePosition = burningStagePosition
        self.created = created
        self.description = description
        self.id = id
        self.lastUpdated = lastUpdated
        self.name = name
        self.passingStagePosition = passingStagePosition
        self.stages = stages
        self.startingStagePosition = startingStagePosition
        self.unlockingStagePosition = unlockingStagePosition
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

        burningStagePosition = try container.decode(Int.self, forKey: .burningStagePosition)
        created = try container.decode(Date.self, forKey: .created)
        description = try container.decode(String.self, forKey: .description)
        name = try container.decode(String.self, forKey: .name)
        passingStagePosition = try container.decode(Int.self, forKey: .passingStagePosition)
        stages = try container.decode([Stage].self, forKey: .stages)
        startingStagePosition = try container.decode(Int.self, forKey: .startingStagePosition)
        unlockingStagePosition = try container.decode(Int.self, forKey: .unlockingStagePosition)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(burningStagePosition, forKey: .burningStagePosition)
        try container.encode(created, forKey: .created)
        try container.encode(description, forKey: .description)
        try container.encode(name, forKey: .name)
        try container.encode(passingStagePosition, forKey: .passingStagePosition)
        try container.encode(stages, forKey: .stages)
        try container.encode(startingStagePosition, forKey: .startingStagePosition)
        try container.encode(unlockingStagePosition, forKey: .unlockingStagePosition)
    }

    /// The unlocking (position 0) and burning (maximum position) will always have `null` for ``interval`` and ``intervalUnit`` since the stages do not influence ``Assignment/available``. Stages in between the unlocking and burning stages are the “reviewable” stages.
    public struct Stage: Codable, Hashable {
        /// The length of time added to the time of review registration, adjusted to the beginning of the hour.
        public var interval: Int?
        /// Unit of time. Can be the following: `milliseconds`, `seconds`, `minutes`, `hours`, `days`, or `weeks`.
        public var intervalUnit: String?
        /// The position of the stage within the continuous order.
        public var position: Int

        private enum CodingKeys: String, CodingKey {
            case interval
            case intervalUnit = "interval_unit"
            case position
        }
    }

    private enum CodingKeys: String, CodingKey {
        case burningStagePosition = "burning_stage_position"
        case created = "created_at"
        case description
        case name
        case passingStagePosition = "passing_stage_position"
        case stages
        case startingStagePosition = "starting_stage_position"
        case unlockingStagePosition = "unlocking_stage_position"
    }
}
