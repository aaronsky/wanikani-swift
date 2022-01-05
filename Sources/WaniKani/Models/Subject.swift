import Foundation

/// Common properties shared between all Subject variants.
public protocol SubjectProtocol {
    /// Collection of auxiliary meanings.
    var auxiliaryMeanings: [AuxiliaryMeaning] { get }
    /// Timestamp when the subject was created.
    var created: Date { get }
    /// A URL pointing to the page on wanikani.com that provides detailed information about this subject.
    var documentURL: URL { get }
    /// Timestamp when the subject was hidden, indicating associated assignments will no longer appear in lessons or reviews and that the subject page is no longer visible on wanikani.com.
    var hidden: Date? { get }
    /// The position that the subject appears in lessons. Note that the value is scoped to the level of the subject, so there are duplicate values across levels.
    var lessonPosition: Int { get }
    /// The level of the subject, from `1` to `60`.
    var level: Int { get }
    /// The subject's meaning mnemonic.
    var meaningMnemonic: String { get }
    /// The subject meanings.
    var meanings: [Meaning] { get }
    /// The string that is used when generating the document URL for the subject. Radicals use their meaning, downcased. Kanji and vocabulary use their characters.
    var slug: String { get }
    /// Unique identifier of the associated ``SpacedRepetitionSystem``.
    var spacedRepetitionSystemID: Int { get }
}

/// Subjects are the radicals, kanji, and vocabulary that are learned through lessons and reviews. They contain basic dictionary information,
/// such as meanings and/or readings, and information about their relationship to other items with WaniKani, like their level.
///
/// The exact structure of a subject depends on the subject type. Note that any attributes called out for the specific subject type behaves differently than the common attribute of the same name.
public enum Subject: ModelProtocol {
    case radical(Radical)
    case kanji(Kanji)
    case vocabulary(Vocabulary)

    public var object: String {
        switch self {
        case .radical(let radical):
            return radical.object
        case .kanji(let kanji):
            return kanji.object
        case .vocabulary(let vocabulary):
            return vocabulary.object
        }
    }

    public var id: Int {
        switch self {
        case .radical(let radical):
            return radical.id
        case .kanji(let kanji):
            return kanji.id
        case .vocabulary(let vocabulary):
            return vocabulary.id
        }
    }

    public var url: URL {
        switch self {
        case .radical(let radical):
            return radical.url
        case .kanji(let kanji):
            return kanji.url
        case .vocabulary(let vocabulary):
            return vocabulary.url
        }
    }

    public var lastUpdated: Date? {
        switch self {
        case .radical(let radical):
            return radical.lastUpdated
        case .kanji(let kanji):
            return kanji.lastUpdated
        case .vocabulary(let vocabulary):
            return vocabulary.lastUpdated
        }
    }

    public init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let object = try container.decode(String.self, forKey: .object)

        guard let kind = Subject.Kind(rawValue: object) else {
            throw DecodingError.typeMismatch(
                Self.self,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription:
                        "Expected to decode Subject, but no recognized subject type could be derived from object type \(object)"
                )
            )
        }

        switch kind {
        case .radical:
            self = try .radical(Radical(from: decoder))
        case .kanji:
            self = try .kanji(Kanji(from: decoder))
        case .vocabulary:
            self = try .vocabulary(Vocabulary(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .radical(let radical):
            try radical.encode(to: encoder)
        case .kanji(let kanji):
            try kanji.encode(to: encoder)
        case .vocabulary(let vocabulary):
            try vocabulary.encode(to: encoder)
        }
    }

    /// The supported kinds of subjects.
    public enum Kind: String, Codable, Hashable {
        case radical
        case kanji
        case vocabulary
    }

    private enum CodingKeys: String, CodingKey {
        case object
        case data
    }
}

extension Subject: SubjectProtocol {
    public var auxiliaryMeanings: [AuxiliaryMeaning] {
        switch self {
        case .radical(let radical):
            return radical.auxiliaryMeanings
        case .kanji(let kanji):
            return kanji.auxiliaryMeanings
        case .vocabulary(let vocabulary):
            return vocabulary.auxiliaryMeanings
        }
    }

    public var created: Date {
        switch self {
        case .radical(let radical):
            return radical.created
        case .kanji(let kanji):
            return kanji.created
        case .vocabulary(let vocabulary):
            return vocabulary.created
        }
    }

    public var documentURL: URL {
        switch self {
        case .radical(let radical):
            return radical.documentURL
        case .kanji(let kanji):
            return kanji.documentURL
        case .vocabulary(let vocabulary):
            return vocabulary.documentURL
        }
    }

    public var hidden: Date? {
        switch self {
        case .radical(let radical):
            return radical.hidden
        case .kanji(let kanji):
            return kanji.hidden
        case .vocabulary(let vocabulary):
            return vocabulary.hidden
        }
    }

    public var lessonPosition: Int {
        switch self {
        case .radical(let radical):
            return radical.lessonPosition
        case .kanji(let kanji):
            return kanji.lessonPosition
        case .vocabulary(let vocabulary):
            return vocabulary.lessonPosition
        }
    }

    public var level: Int {
        switch self {
        case .radical(let radical):
            return radical.level
        case .kanji(let kanji):
            return kanji.level
        case .vocabulary(let vocabulary):
            return vocabulary.level
        }
    }

    public var meaningMnemonic: String {
        switch self {
        case .radical(let radical):
            return radical.meaningMnemonic
        case .kanji(let kanji):
            return kanji.meaningMnemonic
        case .vocabulary(let vocabulary):
            return vocabulary.meaningMnemonic
        }
    }

    public var meanings: [Meaning] {
        switch self {
        case .radical(let radical):
            return radical.meanings
        case .kanji(let kanji):
            return kanji.meanings
        case .vocabulary(let vocabulary):
            return vocabulary.meanings
        }
    }

    public var slug: String {
        switch self {
        case .radical(let radical):
            return radical.slug
        case .kanji(let kanji):
            return kanji.slug
        case .vocabulary(let vocabulary):
            return vocabulary.slug
        }
    }

    public var spacedRepetitionSystemID: Int {
        switch self {
        case .radical(let radical):
            return radical.spacedRepetitionSystemID
        case .kanji(let kanji):
            return kanji.spacedRepetitionSystemID
        case .vocabulary(let vocabulary):
            return vocabulary.spacedRepetitionSystemID
        }
    }
}

public struct Meaning: Codable, Hashable {
    /// A singular subject meaning.
    public var meaning: String
    /// Indicates priority in the WaniKani system.
    public var isPrimary: Bool
    /// Indicates if the meaning is used to evaluate user input for correctness.
    public var isAcceptedAnswer: Bool

    public init(
        meaning: String,
        isPrimary: Bool,
        isAcceptedAnswer: Bool
    ) {
        self.meaning = meaning
        self.isPrimary = isPrimary
        self.isAcceptedAnswer = isAcceptedAnswer
    }

    private enum CodingKeys: String, CodingKey {
        case meaning
        case isPrimary = "primary"
        case isAcceptedAnswer = "accepted_answer"
    }
}

public struct AuxiliaryMeaning: Codable, Hashable {
    /// A singular subject meaning.
    public var meaning: String
    /// When evaluating user input, allowlisted meanings are used to match for correctness. Blocklisted meanings are used to match for incorrectness.
    public var type: Kind

    public init(
        meaning: String,
        type: Kind
    ) {
        self.meaning = meaning
        self.type = type
    }

    public enum Kind: String, Codable, Hashable {
        case allowlist = "whitelist"
        case blocklist = "blacklist"
    }
}

public struct Radical: ModelProtocol, SubjectProtocol {
    public let object = "radical"

    /// An array of numeric identifiers for the kanji that have the radical as a component.
    public var amalgamationSubjectIDs: [Int]
    public var auxiliaryMeanings: [AuxiliaryMeaning]
    /// The UTF-8 characters for the subject, including kanji and hiragana.
    ///
    /// Unlike kanji and vocabulary, radicals can have a null value for characters. Not all radicals have a UTF entry, so the radical must be visually represented with an image instead.
    public var characters: String?
    /// A collection of images of the radical.
    public var characterImages: [CharacterImage]
    public var created: Date
    public var documentURL: URL
    public var hidden: Date?
    public var id: Int
    public var lastUpdated: Date?
    public var lessonPosition: Int
    public var level: Int
    public var meaningMnemonic: String
    public var meanings: [Meaning]
    public var slug: String
    public var spacedRepetitionSystemID: Int
    public var url: URL

    public init(
        amalgamationSubjectIDs: [Int],
        auxiliaryMeanings: [AuxiliaryMeaning],
        characters: String? = nil,
        characterImages: [CharacterImage],
        created: Date,
        documentURL: URL,
        hidden: Date? = nil,
        id: Int,
        lastUpdated: Date? = nil,
        lessonPosition: Int,
        level: Int,
        meaningMnemonic: String,
        meanings: [Meaning],
        slug: String,
        spacedRepetitionSystemID: Int,
        url: URL
    ) {
        self.amalgamationSubjectIDs = amalgamationSubjectIDs
        self.auxiliaryMeanings = auxiliaryMeanings
        self.characters = characters
        self.characterImages = characterImages
        self.created = created
        self.documentURL = documentURL
        self.hidden = hidden
        self.id = id
        self.lastUpdated = lastUpdated
        self.lessonPosition = lessonPosition
        self.level = level
        self.meaningMnemonic = meaningMnemonic
        self.meanings = meanings
        self.slug = slug
        self.spacedRepetitionSystemID = spacedRepetitionSystemID
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

        amalgamationSubjectIDs = try container.decode([Int].self, forKey: .amalgamationSubjectIDs)
        auxiliaryMeanings = try container.decode([AuxiliaryMeaning].self, forKey: .auxiliaryMeanings)
        characters = try container.decodeIfPresent(String.self, forKey: .characters)
        characterImages = try container.decode([CharacterImage].self, forKey: .characterImages)
        created = try container.decode(Date.self, forKey: .created)
        documentURL = try container.decode(URL.self, forKey: .documentURL)
        hidden = try container.decodeIfPresent(Date.self, forKey: .hidden)
        lessonPosition = try container.decode(Int.self, forKey: .lessonPosition)
        level = try container.decode(Int.self, forKey: .level)
        meaningMnemonic = try container.decode(String.self, forKey: .meaningMnemonic)
        meanings = try container.decode([Meaning].self, forKey: .meanings)
        slug = try container.decode(String.self, forKey: .slug)
        spacedRepetitionSystemID = try container.decode(Int.self, forKey: .spacedRepetitionSystemID)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(amalgamationSubjectIDs, forKey: .amalgamationSubjectIDs)
        try container.encode(auxiliaryMeanings, forKey: .auxiliaryMeanings)
        try container.encode(characters, forKey: .characters)
        try container.encode(characterImages, forKey: .characterImages)
        try container.encode(created, forKey: .created)
        try container.encode(documentURL, forKey: .documentURL)
        try container.encode(hidden, forKey: .hidden)
        try container.encode(lessonPosition, forKey: .lessonPosition)
        try container.encode(level, forKey: .level)
        try container.encode(meaningMnemonic, forKey: .meaningMnemonic)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(slug, forKey: .slug)
        try container.encode(spacedRepetitionSystemID, forKey: .spacedRepetitionSystemID)
    }

    public struct CharacterImage: Codable, Hashable {
        /// The location of the image.
        public var url: URL
        /// The content type of the image. Currently the WaniKani system delivers `image/png` and `image/svg+xml`.
        public var contentType: String
        /// Details about the image.
        public var metadata: Metadata

        public init(
            url: URL,
            metadata: Metadata
        ) {
            self.url = url
            self.metadata = metadata
            switch metadata {
            case .svg:
                self.contentType = "image/svg+xml"
            case .png:
                self.contentType = "image/png"
            }
        }

        public init(
            from decoder: Decoder
        ) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            url = try container.decode(URL.self, forKey: .url)
            contentType = try container.decode(String.self, forKey: .contentType)

            switch contentType {
            case "image/svg+xml":
                metadata = try .svg(container.decode(Metadata.SVG.self, forKey: .metadata))
            case "image/png":
                metadata = try .png(container.decode(Metadata.PNG.self, forKey: .metadata))
            default:
                throw DecodingError.dataCorruptedError(
                    forKey: .metadata,
                    in: container,
                    debugDescription: "Invalid content-type for character image \(contentType)"
                )
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(url, forKey: .url)
            try container.encode(contentType, forKey: .contentType)
            switch metadata {
            case .svg(let svg):
                try container.encode(svg, forKey: .metadata)
            case .png(let png):
                try container.encode(png, forKey: .metadata)
            }
        }

        public enum Metadata: Codable, Hashable {
            case svg(SVG)
            case png(PNG)

            public struct SVG: Codable, Hashable {
                /// The SVG asset contains built-in CSS styling.
                public var containsInlineStyles: Bool

                public init(
                    containsInlineStyles: Bool
                ) {
                    self.containsInlineStyles = containsInlineStyles
                }

                private enum CodingKeys: String, CodingKey {
                    case containsInlineStyles = "inline_styles"
                }
            }

            public struct PNG: Codable, Hashable {
                /// Color of the asset in hexadecimal.
                public var color: String
                // FIXME: WxH as string, or CGSize?
                /// Dimension of the asset in pixels.
                public var dimensions: String
                /// A name descriptor.
                public var styleName: String

                public init(
                    color: String,
                    dimensions: String,
                    styleName: String
                ) {
                    self.color = color
                    self.dimensions = dimensions
                    self.styleName = styleName
                }

                private enum CodingKeys: String, CodingKey {
                    case color
                    case dimensions
                    case styleName = "style_name"
                }
            }
        }

        private enum CodingKeys: String, CodingKey {
            case url
            case contentType = "content_type"
            case metadata
        }
    }

    private enum CodingKeys: String, CodingKey {
        case amalgamationSubjectIDs = "amalgamation_subject_ids"
        case auxiliaryMeanings = "auxiliary_meanings"
        case characters
        case characterImages = "character_images"
        case created = "created_at"
        case documentURL = "document_url"
        case hidden = "hidden_at"
        case lessonPosition = "lesson_position"
        case level
        case meaningMnemonic = "meaning_mnemonic"
        case meanings
        case slug
        case spacedRepetitionSystemID = "spaced_repetition_system_id"
    }
}

public struct Kanji: ModelProtocol, SubjectProtocol {
    public let object = "kanji"

    /// An array of numeric identifiers for the vocabulary that have the kanji as a component.
    public var amalgamationSubjectIDs: [Int]
    public var auxiliaryMeanings: [AuxiliaryMeaning]
    /// The UTF-8 characters for the subject.
    public var characters: String
    /// An array of numeric identifiers for the radicals that make up this kanji. Note that these are the subjects that must have passed assignments in order to unlock this subject's assignment.
    public var componentSubjectIDs: [Int]
    public var created: Date
    public var documentURL: URL
    public var hidden: Date?
    public var id: Int
    public var lastUpdated: Date?
    public var lessonPosition: Int
    public var level: Int
    /// Meaning hint for the kanji.
    public var meaningHint: String?
    public var meaningMnemonic: String
    public var meanings: [Meaning]
    /// Reading hint for the kanji.
    public var readingHint: String?
    /// The kanji's reading mnemonic.
    public var readingMnemonic: String
    /// Selected readings for the kanji.
    public var readings: [Reading]
    public var slug: String
    public var spacedRepetitionSystemID: Int
    /// An array of numeric identifiers for kanji which are visually similar to the kanji in question.
    public var visuallySimilarSubjectIDs: [Int]
    public var url: URL

    public init(
        amalgamationSubjectIDs: [Int],
        auxiliaryMeanings: [AuxiliaryMeaning],
        characters: String,
        componentSubjectIDs: [Int],
        created: Date,
        documentURL: URL,
        hidden: Date? = nil,
        id: Int,
        lastUpdated: Date? = nil,
        lessonPosition: Int,
        level: Int,
        meaningHint: String? = nil,
        meaningMnemonic: String,
        meanings: [Meaning],
        readingHint: String? = nil,
        readingMnemonic: String,
        readings: [Reading],
        slug: String,
        spacedRepetitionSystemID: Int,
        visuallySimilarSubjectIDs: [Int],
        url: URL
    ) {
        self.amalgamationSubjectIDs = amalgamationSubjectIDs
        self.auxiliaryMeanings = auxiliaryMeanings
        self.characters = characters
        self.componentSubjectIDs = componentSubjectIDs
        self.created = created
        self.documentURL = documentURL
        self.hidden = hidden
        self.id = id
        self.lastUpdated = lastUpdated
        self.lessonPosition = lessonPosition
        self.level = level
        self.meaningHint = meaningHint
        self.meaningMnemonic = meaningMnemonic
        self.meanings = meanings
        self.readingHint = readingHint
        self.readingMnemonic = readingMnemonic
        self.readings = readings
        self.slug = slug
        self.spacedRepetitionSystemID = spacedRepetitionSystemID
        self.visuallySimilarSubjectIDs = visuallySimilarSubjectIDs
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

        amalgamationSubjectIDs = try container.decode([Int].self, forKey: .amalgamationSubjectIDs)
        auxiliaryMeanings = try container.decode([AuxiliaryMeaning].self, forKey: .auxiliaryMeanings)
        characters = try container.decode(String.self, forKey: .characters)
        componentSubjectIDs = try container.decode([Int].self, forKey: .componentSubjectIDs)
        created = try container.decode(Date.self, forKey: .created)
        documentURL = try container.decode(URL.self, forKey: .documentURL)
        hidden = try container.decodeIfPresent(Date.self, forKey: .hidden)
        lessonPosition = try container.decode(Int.self, forKey: .lessonPosition)
        level = try container.decode(Int.self, forKey: .level)
        meaningHint = try container.decodeIfPresent(String.self, forKey: .meaningHint)
        meaningMnemonic = try container.decode(String.self, forKey: .meaningMnemonic)
        meanings = try container.decode([Meaning].self, forKey: .meanings)
        readingHint = try container.decodeIfPresent(String.self, forKey: .readingHint)
        readingMnemonic = try container.decode(String.self, forKey: .readingMnemonic)
        readings = try container.decode([Reading].self, forKey: .readings)
        slug = try container.decode(String.self, forKey: .slug)
        spacedRepetitionSystemID = try container.decode(Int.self, forKey: .spacedRepetitionSystemID)
        visuallySimilarSubjectIDs = try container.decode([Int].self, forKey: .visuallySimilarSubjectIDs)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(amalgamationSubjectIDs, forKey: .amalgamationSubjectIDs)
        try container.encode(auxiliaryMeanings, forKey: .auxiliaryMeanings)
        try container.encode(characters, forKey: .characters)
        try container.encode(componentSubjectIDs, forKey: .componentSubjectIDs)
        try container.encode(created, forKey: .created)
        try container.encode(documentURL, forKey: .documentURL)
        try container.encode(hidden, forKey: .hidden)
        try container.encode(lessonPosition, forKey: .lessonPosition)
        try container.encode(level, forKey: .level)
        try container.encode(meaningHint, forKey: .meaningHint)
        try container.encode(meaningMnemonic, forKey: .meaningMnemonic)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(readingHint, forKey: .readingHint)
        try container.encode(readingMnemonic, forKey: .readingMnemonic)
        try container.encode(readings, forKey: .readings)
        try container.encode(slug, forKey: .slug)
        try container.encode(spacedRepetitionSystemID, forKey: .spacedRepetitionSystemID)
        try container.encode(visuallySimilarSubjectIDs, forKey: .visuallySimilarSubjectIDs)
    }

    public struct Reading: Codable, Hashable {
        /// A singular subject reading.
        public var reading: String
        /// Indicates priority in the WaniKani system.
        public var isPrimary: Bool
        /// Indicates if the reading is used to evaluate user input for correctness.
        public var isAcceptedAnswer: Bool
        /// The kanji reading's classfication.
        public var type: Kind

        public init(
            reading: String,
            isPrimary: Bool,
            isAcceptedAnswer: Bool,
            type: Kind
        ) {
            self.reading = reading
            self.isPrimary = isPrimary
            self.isAcceptedAnswer = isAcceptedAnswer
            self.type = type
        }

        public enum Kind: String, Codable, Hashable {
            case kunyomi
            case nanori
            case onyomi
        }

        private enum CodingKeys: String, CodingKey {
            case reading
            case isPrimary = "primary"
            case isAcceptedAnswer = "accepted_answer"
            case type
        }
    }

    private enum CodingKeys: String, CodingKey {
        case amalgamationSubjectIDs = "amalgamation_subject_ids"
        case auxiliaryMeanings = "auxiliary_meanings"
        case characters
        case componentSubjectIDs = "component_subject_ids"
        case created = "created_at"
        case documentURL = "document_url"
        case hidden = "hidden_at"
        case lessonPosition = "lesson_position"
        case level
        case meanings
        case meaningHint = "meaning_hint"
        case meaningMnemonic = "meaning_mnemonic"
        case readings
        case readingHint = "reading_hint"
        case readingMnemonic = "reading_mnemonic"
        case slug
        case spacedRepetitionSystemID = "spaced_repetition_system_id"
        case visuallySimilarSubjectIDs = "visually_similar_subject_ids"
    }
}

public struct Vocabulary: ModelProtocol, SubjectProtocol {
    public let object = "vocabulary"

    public var auxiliaryMeanings: [AuxiliaryMeaning]
    /// The UTF-8 characters for the subject, including kanji and hiragana.
    public var characters: String
    /// An array of numeric identifiers for the kanji that make up this vocabulary. Note that these are the subjects that must be have passed assignments in order to unlock this subject's assignment.
    public var componentSubjectIDs: [Int]
    /// A collection of context sentences.
    public var contextSentences: [ContextSentence]
    public var created: Date
    public var documentURL: URL
    public var hidden: Date?
    public var id: Int
    public var lastUpdated: Date?
    public var lessonPosition: Int
    public var level: Int
    /// The subject's meaning mnemonic.
    public var meaningMnemonic: String
    public var meanings: [Meaning]
    /// Parts of speech.
    public var partsOfSpeech: [String]
    /// A collection of pronunciation audio.
    public var pronunciationAudios: [PronunciationAudio]
    /// Selected readings for the vocabulary.
    public var readings: [Reading]
    /// The subject's reading mnemonic.
    public var readingMnemonic: String
    public var slug: String
    public var spacedRepetitionSystemID: Int
    public var url: URL

    public init(
        auxiliaryMeanings: [AuxiliaryMeaning],
        characters: String,
        componentSubjectIDs: [Int],
        contextSentences: [ContextSentence],
        created: Date,
        documentURL: URL,
        hidden: Date? = nil,
        id: Int,
        lastUpdated: Date? = nil,
        lessonPosition: Int,
        level: Int,
        meaningMnemonic: String,
        meanings: [Meaning],
        partsOfSpeech: [String],
        pronunciationAudios: [PronunciationAudio],
        readings: [Reading],
        readingMnemonic: String,
        slug: String,
        spacedRepetitionSystemID: Int,
        url: URL
    ) {
        self.auxiliaryMeanings = auxiliaryMeanings
        self.characters = characters
        self.componentSubjectIDs = componentSubjectIDs
        self.contextSentences = contextSentences
        self.created = created
        self.documentURL = documentURL
        self.hidden = hidden
        self.id = id
        self.lastUpdated = lastUpdated
        self.lessonPosition = lessonPosition
        self.level = level
        self.meaningMnemonic = meaningMnemonic
        self.meanings = meanings
        self.partsOfSpeech = partsOfSpeech
        self.pronunciationAudios = pronunciationAudios
        self.readings = readings
        self.readingMnemonic = readingMnemonic
        self.slug = slug
        self.spacedRepetitionSystemID = spacedRepetitionSystemID
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

        auxiliaryMeanings = try container.decode([AuxiliaryMeaning].self, forKey: .auxiliaryMeanings)
        characters = try container.decode(String.self, forKey: .characters)
        componentSubjectIDs = try container.decode([Int].self, forKey: .componentSubjectIDs)
        contextSentences = try container.decode([ContextSentence].self, forKey: .contextSentences)
        created = try container.decode(Date.self, forKey: .created)
        documentURL = try container.decode(URL.self, forKey: .documentURL)
        hidden = try container.decodeIfPresent(Date.self, forKey: .hidden)
        lessonPosition = try container.decode(Int.self, forKey: .lessonPosition)
        level = try container.decode(Int.self, forKey: .level)
        meaningMnemonic = try container.decode(String.self, forKey: .meaningMnemonic)
        meanings = try container.decode([Meaning].self, forKey: .meanings)
        partsOfSpeech = try container.decode([String].self, forKey: .partsOfSpeech)
        pronunciationAudios = try container.decode([PronunciationAudio].self, forKey: .pronunciationAudios)
        readings = try container.decode([Reading].self, forKey: .readings)
        readingMnemonic = try container.decode(String.self, forKey: .readingMnemonic)
        slug = try container.decode(String.self, forKey: .slug)
        spacedRepetitionSystemID = try container.decode(Int.self, forKey: .spacedRepetitionSystemID)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(auxiliaryMeanings, forKey: .auxiliaryMeanings)
        try container.encode(characters, forKey: .characters)
        try container.encode(componentSubjectIDs, forKey: .componentSubjectIDs)
        try container.encode(contextSentences, forKey: .contextSentences)
        try container.encode(created, forKey: .created)
        try container.encode(documentURL, forKey: .documentURL)
        try container.encode(hidden, forKey: .hidden)
        try container.encode(lessonPosition, forKey: .lessonPosition)
        try container.encode(level, forKey: .level)
        try container.encode(meaningMnemonic, forKey: .meaningMnemonic)
        try container.encode(meanings, forKey: .meanings)
        try container.encode(partsOfSpeech, forKey: .partsOfSpeech)
        try container.encode(pronunciationAudios, forKey: .pronunciationAudios)
        try container.encode(readings, forKey: .readings)
        try container.encode(readingMnemonic, forKey: .readingMnemonic)
        try container.encode(slug, forKey: .slug)
        try container.encode(spacedRepetitionSystemID, forKey: .spacedRepetitionSystemID)
    }

    public struct ContextSentence: Codable, Hashable {
        public var englishSentence: String
        public var japaneseSentence: String

        public init(
            english: String,
            japanese: String
        ) {
            self.englishSentence = english
            self.japaneseSentence = japanese
        }

        private enum CodingKeys: String, CodingKey {
            case englishSentence = "en"
            case japaneseSentence = "ja"
        }
    }

    public struct PronunciationAudio: Codable, Hashable {
        /// The location of the audio.
        public var url: URL
        /// The content type of the audio. Currently the API delivers `audio/mpeg` and `audio/ogg`.
        public var contentType: String
        /// Details about the pronunciation audio.
        public var metadata: Metadata

        public init(
            url: URL,
            contentType: String,
            metadata: Vocabulary.PronunciationAudio.Metadata
        ) {
            self.url = url
            self.contentType = contentType
            self.metadata = metadata
        }

        public struct Metadata: Codable, Hashable {
            /// The gender of the voice actor.
            public var gender: String
            /// A unique ID shared between same source pronunciation audio.
            public var sourceID: Int
            /// Vocabulary being pronounced in kana.
            public var pronunciation: String
            /// A unique ID belonging to the voice actor.
            public var voiceActorID: Int
            /// Humanized name of the voice actor.
            public var voiceActorName: String
            /// Description of the voice.
            public var voiceDescription: String

            public init(
                gender: String,
                sourceID: Int,
                pronunciation: String,
                voiceActorID: Int,
                voiceActorName: String,
                voiceDescription: String
            ) {
                self.gender = gender
                self.sourceID = sourceID
                self.pronunciation = pronunciation
                self.voiceActorID = voiceActorID
                self.voiceActorName = voiceActorName
                self.voiceDescription = voiceDescription
            }

            private enum CodingKeys: String, CodingKey {
                case gender
                case sourceID = "source_id"
                case pronunciation
                case voiceActorID = "voice_actor_id"
                case voiceActorName = "voice_actor_name"
                case voiceDescription = "voice_description"
            }
        }

        private enum CodingKeys: String, CodingKey {
            case url
            case contentType = "content_type"
            case metadata
        }
    }

    public struct Reading: Codable, Hashable {
        /// A singular subject reading.
        public var reading: String
        /// Indicates priority in the WaniKani system.
        public var isPrimary: Bool
        /// Indicates if the reading is used to evaluate user input for correctness.
        public var isAcceptedAnswer: Bool

        public init(
            reading: String,
            isPrimary: Bool,
            isAcceptedAnswer: Bool
        ) {
            self.reading = reading
            self.isPrimary = isPrimary
            self.isAcceptedAnswer = isAcceptedAnswer
        }

        private enum CodingKeys: String, CodingKey {
            case reading
            case isPrimary = "primary"
            case isAcceptedAnswer = "accepted_answer"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case auxiliaryMeanings = "auxiliary_meanings"
        case characters
        case componentSubjectIDs = "component_subject_ids"
        case contextSentences = "context_sentences"
        case created = "created_at"
        case documentURL = "document_url"
        case hidden = "hidden_at"
        case lessonPosition = "lesson_position"
        case level
        case meaningMnemonic = "meaning_mnemonic"
        case meanings
        case partsOfSpeech = "parts_of_speech"
        case pronunciationAudios = "pronunciation_audios"
        case readings
        case readingMnemonic = "reading_mnemonic"
        case slug
        case spacedRepetitionSystemID = "spaced_repetition_system_id"
    }
}
