import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Assignments {
    /// Returns a collection of all assignments, ordered by ascending creation date, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<Assignment>

        public let path = "assignments"

        /// Only assignments available at or after this time are returned.
        var availableAfter: Date?
        /// Only assignments available at or before this time are returned.
        var availableBefore: Date?
        /// When set to `true`, returns assignments that have a value in ``Assignment/burned``. Returns assignments with a `null` ``Assignment/burned`` if `false`.
        var isBurned: Bool?
        /// Return assignments with a matching value in the hidden attribute.
        var isHidden: Bool?
        /// When set to `true`, returns assignments that have a value in ``Assignment/unlocked``. Returns assignments with a `null` ``Assignment/unlocked`` if `false`.
        var isUnlocked: Bool?
        /// Only assignments where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Returns assignments which are immediately available for lessons.
        var immediatelyAvailableForLessons: Bool?
        /// Returns assignments which are immediately available for review.
        var immediatelyAvailableForReview: Bool?
        /// Returns assignments which are in the review state.
        var inReview: Bool?
        /// Only assignments where the associated subject level matches one of the array values are returned. Valid values range from `1` to `60`.
        var levels: [Int]?
        /// Only assignments where ``Assignment/srsStage`` matches one of the array values are returned. Valid values range from `0` to `9`.
        var srsStages: [Int]?
        /// When set to `true`, returns assignments that have a value in ``Assignment/started``. Returns assignments with a `null` ``Assignment/started`` if `false`.
        var isStarted: Bool?
        /// Only assignments where ``Assignment/subjectID`` matches one of the array values are returned.
        var subjectIDs: [Int]?
        /// Only assignments where ``Assignment/subjectType`` matches one of the array values are returned.
        var subjectTypes: [Subject.Kind]?
        /// Only assignments updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                      return
                  }

            var queryItems = components.queryItems ?? []
            queryItems.appendIfNeeded(availableAfter, forKey: "available_after")
            queryItems.appendIfNeeded(availableBefore, forKey: "available_before")
            queryItems.appendIfNeeded(isBurned, forKey: "burned")
            queryItems.appendIfNeeded(isHidden, forKey: "hidden")
            queryItems.appendIfNeeded(isUnlocked, forKey: "unlocked")
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(immediatelyAvailableForLessons, forKey: "immediately_available_for_lessons")
            queryItems.appendIfNeeded(immediatelyAvailableForReview, forKey: "immediately_available_for_review")
            queryItems.appendIfNeeded(inReview, forKey: "in_review")
            queryItems.appendIfNeeded(levels, forKey: "levels")
            queryItems.appendIfNeeded(srsStages, forKey: "srs_stages")
            queryItems.appendIfNeeded(isStarted, forKey: "started")
            queryItems.appendIfNeeded(subjectIDs, forKey: "subject_ids")
            queryItems.appendIfNeeded(subjectTypes, forKey: "subject_types")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific assignment by its id.
    public struct Get: Resource {
        public typealias Content = Assignment

        /// Unique identifier of the assignment.
        public var id: Int

        public var path: String {
            "assignments/\(id)"
        }
    }

    /// Mark the assignment as started, moving the assignment from the lessons queue to the review queue. Returns the updated assignment.
    ///
    /// The assignment must be in the following valid state:
    /// - ``Assignment/level``: Must be less than or equal to the lowest value of ``User/level`` and ``User/Subscription-swift.struct/maxLevelGranted``.
    /// - ``Assignment/srsStage``: Must be equal to `0`.
    /// - ``Assignment/started``: Must be equal to `null`.
    /// - ``Assignment/unlocked``: Must not be `null`.
    public struct Start: Resource {
        public typealias Content = Assignment

        /// Unique identifier of the assignment.
        public var id: Int

        public var body: Body

        public struct Body: Codable {
            /// If not set, ``startedAt`` will default to the time the request is made.
            /// ``startedAt`` must be greater than or equal to ``Assignment/unlocked``.
            public var startedAt: Date?
        }

        public var path: String {
            "assignments/\(id)/start"
        }

        public func transformRequest(_ request: inout URLRequest) {
            request.httpMethod = "PUT"
        }
    }
}

extension Resource where Self == Assignments.List {
    /// Returns a collection of all ``Assignment``s, ordered by ascending creation date, 500 at a time.
    public static func assignments(
        availableAfter: Date? = nil,
        availableBefore: Date? = nil,
        isBurned: Bool? = nil,
        isHidden: Bool? = nil,
        isUnlocked: Bool? = nil,
        ids: [Int]? = nil,
        immediatelyAvailableForLessons: Bool? = nil,
        immediatelyAvailableForReview: Bool? = nil,
        inReview: Bool? = nil,
        levels: [Int]? = nil,
        srsStages: [Int]? = nil,
        isStarted: Bool? = nil,
        subjectIDs: [Int]? = nil,
        subjectTypes: [Subject.Kind]? = nil,
        updatedAfter: Date? = nil
    ) -> Self {
        Self(availableAfter: availableAfter,
             availableBefore: availableBefore,
             isBurned: isBurned,
             isHidden: isHidden,
             isUnlocked: isUnlocked,
             ids: ids,
             immediatelyAvailableForLessons: immediatelyAvailableForLessons,
             immediatelyAvailableForReview: immediatelyAvailableForReview,
             inReview: inReview,
             levels: levels,
             srsStages: srsStages,
             isStarted: isStarted,
             subjectIDs: subjectIDs,
             subjectTypes: subjectTypes,
             updatedAfter: updatedAfter)
    }
}

extension Resource where Self == Assignments.Get {
    /// Retrieves a specific ``Assignment`` by its id.
    public static func assignment(_ id: Int) -> Self {
        Self(id: id)
    }
}

extension Resource where Self == Assignments.Start {
    /// Mark the assignment as started, moving the assignment from the lessons queue to the review queue. Returns the updated assignment.
    public static func startAssignment(_ id: Int, startedAt: Date? = nil) -> Self {
        Self(id: id, body: Self.Body(startedAt: startedAt))
    }
}
