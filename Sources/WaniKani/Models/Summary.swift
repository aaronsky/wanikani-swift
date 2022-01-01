import Foundation

/// The summary report contains currently available lessons and reviews and the reviews that will become available in the next 24 hours, grouped by the hour.
public struct Summary: ModelProtocol {
    public let object = "report"

    public var id: Int
    public var lastUpdated: Date?
    /// Details about subjects available for lessons.
    public var lessons: [Lesson]
    /// Earliest date when the reviews are available. Is null when the user has no reviews scheduled.
    public var nextReviews: Date?
    /// Details about subjects available for reviews now and in the next 24 hours by the hour (total of 25 objects).
    public var reviews: [Review]
    public var url: URL

    init(
        id: Int,
        lastUpdated: Date? = nil,
        lessons: [Summary.Lesson],
        nextReviews: Date? = nil,
        reviews: [Summary.Review],
        url: URL
    ) {
        self.id = id
        self.lastUpdated = lastUpdated
        self.lessons = lessons
        self.nextReviews = nextReviews
        self.reviews = reviews
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

        lessons = try container.decode([Lesson].self, forKey: .lessons)
        nextReviews = try container.decodeIfPresent(Date.self, forKey: .nextReviews)
        reviews = try container.decode([Review].self, forKey: .reviews)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(id, forKey: .id)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(lessons, forKey: .lessons)
        try container.encode(nextReviews, forKey: .nextReviews)
        try container.encode(reviews, forKey: .reviews)
    }

    public struct Lesson: Codable, Equatable {
        /// When the paired ``subjectIDs`` are available for lessons. Always beginning of the current hour when the API endpoint is accessed.
        public var available: Date
        /// Collection of unique identifiers for ``Subject``s.
        public var subjectIDs: [Int]

        private enum CodingKeys: String, CodingKey {
            case available = "available_at"
            case subjectIDs = "subject_ids"
        }
    }

    public struct Review: Codable, Equatable {
        /// When the paired ``subjectIDs`` are available for reviews. All timestamps are the top of an hour.
        public var available: Date
        /// Collection of unique identifiers for ``Subject``s.
        public var subjectIDs: [Int]

        private enum CodingKeys: String, CodingKey {
            case available = "available_at"
            case subjectIDs = "subject_ids"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case lessons
        case nextReviews = "next_reviews"
        case reviews
    }
}
