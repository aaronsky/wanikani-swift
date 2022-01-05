import Foundation

/// Available voice actors used for vocabulary reading pronunciation audio.
public struct VoiceActor: ModelProtocol {
    public let object = "voice_actor"

    /// Details about the voice actor.
    public var description: String
    /// WaniKani system will return `male` or `female`.
    public var gender: String
    public var id: Int
    public var lastUpdated: Date?
    /// The voice actor's name.
    public var name: String
    public var url: URL

    public init(
        description: String,
        gender: String,
        id: Int,
        lastUpdated: Date? = nil,
        name: String,
        url: URL
    ) {
        self.description = description
        self.gender = gender
        self.id = id
        self.lastUpdated = lastUpdated
        self.name = name
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

        description = try container.decode(String.self, forKey: .description)
        gender = try container.decode(String.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)

        try container.encode(description, forKey: .description)
        try container.encode(gender, forKey: .gender)
        try container.encode(name, forKey: .name)
    }

    private enum CodingKeys: String, CodingKey {
        case description
        case gender
        case name
    }
}
