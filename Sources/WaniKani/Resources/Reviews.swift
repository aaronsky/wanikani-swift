import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Reviews {
    /// Returns a collection of all ``Review``s, ordered by ascending creation date, 1000 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<Review>

        public let path = "reviews"

        /// Only reviews where ``Review/assignmentID`` matches one of the array values are returned.
        var assignmentIDs: [Int]?
        /// Only reviews where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only reviews where ``Review/subjectID`` matches one of the array values are returned.
        var subjectIDs: [Int]?
        /// Only reviews updated after this time are returned.
        var updatedAfter: Date?

        public init(
            assignmentIDs: [Int]? = nil,
            ids: [Int]? = nil,
            subjectIDs: [Int]? = nil,
            updatedAfter: Date? = nil
        ) {
            self.assignmentIDs = assignmentIDs
            self.ids = ids
            self.subjectIDs = subjectIDs
            self.updatedAfter = updatedAfter
        }

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                return
            }

            var queryItems = components.queryItems ?? []
            queryItems.appendIfNeeded(assignmentIDs, forKey: "assignment_ids")
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(subjectIDs, forKey: "subject_ids")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``Review`` by its `id`.
    public struct Get: Resource {
        public typealias Content = Review

        /// Unique identifier of the review.
        public var id: Int

        public init(
            id: Int
        ) {
            self.id = id
        }

        public var path: String {
            "reviews/\(id)"
        }
    }

    /// Creates a ``Review`` for a specific assignment `id`. Using the related ``Body-swift.struct/subjectID`` field is also a valid alternative to using ``Body-swift.struct/assignmentID``.
    ///
    /// Some criteria must be met in order for a review to be created: ``Assignment/available`` must be not `null` and in the past.
    ///
    /// When a review is registered, the associated ``Assignment`` and ``ReviewStatistic`` are both updated. These are returned in the response body under `resources_updated`.
    public struct Create: Resource {
        public typealias Content = Review

        public var body: Body

        public struct Body: Codable {
            /// Unique identifier of the assignment. This or ``subjectID`` must be set.
            public var assignmentID: Int?
            /// Unique identifier of the subject. This or ``assignmentID`` must be set.
            public var subjectID: Int?
            /// This is the number of times the meaning was answered **incorrectly**.
            public var incorrectMeaningAnswers: UInt
            /// This is the number of times the reading was answered **incorrectly**. Note that subjects with a `type` of ``Subject/Kind/radical`` do not quiz on readings. Thus, set this value to `0`.
            public var incorrectReadingAnswers: UInt
            /// Timestamp when the review was completed. Defaults to the time of the request if omitted from the request body. Must be in the past, but after ``Assignment/available``.
            public var createdAt: Date?

            public init(
                assignmentID: Int?,
                subjectID: Int?,
                incorrectMeaningAnswers: UInt,
                incorrectReadingAnswers: UInt,
                createdAt: Date?
            ) {
                self.assignmentID = assignmentID
                self.subjectID = subjectID
                self.incorrectMeaningAnswers = incorrectMeaningAnswers
                self.incorrectReadingAnswers = incorrectReadingAnswers
                self.createdAt = createdAt
            }

            public init(
                from decoder: Decoder
            ) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let body = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .review)
                assignmentID = try body.decodeIfPresent(Int.self, forKey: .assignmentID)
                subjectID = try body.decodeIfPresent(Int.self, forKey: .subjectID)
                incorrectMeaningAnswers = try body.decode(UInt.self, forKey: .incorrectMeaningAnswers)
                incorrectReadingAnswers = try body.decode(UInt.self, forKey: .incorrectReadingAnswers)
                createdAt = try body.decodeIfPresent(Date.self, forKey: .createdAt)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var body = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .review)
                try body.encodeIfPresent(assignmentID, forKey: .assignmentID)
                try body.encodeIfPresent(subjectID, forKey: .subjectID)
                try body.encodeIfPresent(incorrectMeaningAnswers, forKey: .incorrectMeaningAnswers)
                try body.encodeIfPresent(incorrectReadingAnswers, forKey: .incorrectReadingAnswers)
                try body.encodeIfPresent(createdAt, forKey: .createdAt)
            }

            private enum CodingKeys: String, CodingKey {
                case review
                case assignmentID = "assignment_id"
                case subjectID = "subject_id"
                case incorrectMeaningAnswers = "incorrect_meaning_answers"
                case incorrectReadingAnswers = "incorrect_reading_answers"
                case createdAt = "created_at"
            }
        }

        public let path = "reviews"

        public init(
            body: Body
        ) {
            self.body = body
        }

        public func transformRequest(_ request: inout URLRequest) {
            request.httpMethod = "POST"
        }
    }
}

extension Resource where Self == Reviews.List {
    /// Returns a collection of all ``Review``s, ordered by ascending creation date, 1000 at a time.
    public static func reviews(
        assignmentIDs: [Int]? = nil,
        ids: [Int]? = nil,
        subjectIDs: [Int]? = nil,
        updatedAfter: Date? = nil
    ) -> Self {
        Self(
            assignmentIDs: assignmentIDs,
            ids: ids,
            subjectIDs: subjectIDs,
            updatedAfter: updatedAfter
        )
    }
}

extension Resource where Self == Reviews.Get {
    /// Retrieves a specific ``Review`` by its `id`.
    public static func review(_ id: Int) -> Self {
        Self(id: id)
    }
}

extension Resource where Self == Reviews.Create {
    /// Creates a ``Review`` for a specific assignment `id`. Using the related ``Reviews/Create/Body-swift.struct/subjectID`` field is also a valid alternative to using ``Reviews/Create/Body-swift.struct/assignmentID``.
    public static func createReview(
        assignmentID: Int? = nil,
        subjectID: Int? = nil,
        incorrectMeaningAnswers: UInt = 0,
        incorrectReadingAnswers: UInt = 0,
        createdAt: Date? = nil
    ) -> Self {
        Self(
            body: Self.Body(
                assignmentID: assignmentID,
                subjectID: subjectID,
                incorrectMeaningAnswers: incorrectMeaningAnswers,
                incorrectReadingAnswers: incorrectReadingAnswers,
                createdAt: createdAt
            )
        )
    }
}
