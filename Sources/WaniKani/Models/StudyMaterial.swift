import Foundation

/// Study materials store user-specific notes and synonyms for a given subject. The records are created as soon as the user enters any study information.
public struct StudyMaterial: ModelProtocol {
    public let object = "study_material"

    /// Timestamp when the study material was created.
    public var created: Date
    public var id: Int
    /// Indicates if the associated subject has been hidden, preventing it from appearing in lessons or reviews.
    public var isHidden: Bool
    public var lastUpdated: Date?
    /// Free form note related to the meaning(s) of the associated subject.
    public var meaningNote: String?
    /// Synonyms for the meaning of the subject. These are used as additional correct answers during reviews.
    public var meaningSynonyms: [String]
    /// Free form note related to the reading(s) of the associated subject.
    public var readingNote: String?
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
        meaningNote: String? = nil,
        meaningSynonyms: [String],
        readingNote: String? = nil,
        subjectID: Int,
        subjectType: Subject.Kind,
        url: URL
    ) {
        self.created = created
        self.id = id
        self.isHidden = isHidden
        self.lastUpdated = lastUpdated
        self.meaningNote = meaningNote
        self.meaningSynonyms = meaningSynonyms
        self.readingNote = readingNote
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
        meaningNote = try container.decodeIfPresent(String.self, forKey: .meaningNote)
        meaningSynonyms = try container.decode([String].self, forKey: .meaningSynonyms)
        readingNote = try container.decodeIfPresent(String.self, forKey: .readingNote)
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
        try container.encode(meaningNote, forKey: .meaningNote)
        try container.encode(meaningSynonyms, forKey: .meaningSynonyms)
        try container.encode(readingNote, forKey: .readingNote)
        try container.encode(subjectID, forKey: .subjectID)
        try container.encode(subjectType, forKey: .subjectType)
    }

    private enum CodingKeys: String, CodingKey {
        case created = "created_at"
        case isHidden = "hidden"
        case meaningNote = "meaning_note"
        case meaningSynonyms = "meaning_synonyms"
        case readingNote = "reading_note"
        case subjectID = "subject_id"
        case subjectType = "subject_type"
    }
}
