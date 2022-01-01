import Foundation

public enum ReviewStatistics {
    /// Returns a collection of all ``ReviewStatistic``s, ordered by ascending creation date, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<ReviewStatistic>

        public let path = "review_statistics"

        /// Return review statistics with a matching value in the ``ReviewStatistic/isHidden`` attribute.
        var isHidden: Bool?
        /// Only review statistics where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Return review statistics where the ``ReviewStatistic/percentageCorrect`` is greater than the value.
        var percentagesGreaterThan: Int?
        /// Return review statistics where the ``ReviewStatistic/percentageCorrect`` is less than the value.
        var percentagesLessThan: Int?
        /// Only review statistics where ``ReviewStatistic/subjectID`` matches one of the array values are returned.
        var subjectIDs: [Int]?
        /// Only review statistics where ``ReviewStatistic/subjectType`` matches one of the array values are returned.
        var subjectTypes: [Subject.Kind]?
        /// Only review statistics updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                      return
                  }

            var queryItems: [URLQueryItem] = []

            queryItems.appendIfNeeded(isHidden, forKey: "hidden")
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(percentagesGreaterThan, forKey: "percentages_greater_than")
            queryItems.appendIfNeeded(percentagesLessThan, forKey: "percentages_less_than")
            queryItems.appendIfNeeded(subjectIDs, forKey: "subject_ids")
            queryItems.appendIfNeeded(subjectTypes, forKey: "subject_types")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``ReviewStatistic`` by its `id`.
    public struct Get: Resource {
        public typealias Content = ReviewStatistic

        /// Unique identifier of the ``ReviewStatistic``.
        public var id: Int

        public var path: String {
            "review_statistics/\(id)"
        }
    }
}

extension Resource where Self == ReviewStatistics.List {
    /// Returns a collection of all ``ReviewStatistic``s, ordered by ascending creation date, 500 at a time.
    public static func reviewStatistics(
        isHidden: Bool? = nil,
        ids: [Int]? = nil,
        percentagesGreaterThan: Int? = nil,
        percentagesLessThan: Int? = nil,
        subjectIDs: [Int]? = nil,
        subjectTypes: [Subject.Kind]? = nil,
        updatedAfter: Date? = nil
    ) -> Self {
        Self(isHidden: isHidden,
             ids: ids,
             percentagesGreaterThan: percentagesGreaterThan,
             percentagesLessThan: percentagesLessThan,
             subjectIDs: subjectIDs,
             subjectTypes: subjectTypes,
             updatedAfter: updatedAfter)
    }
}

extension Resource where Self == ReviewStatistics.Get {
    /// Retrieves a specific ``ReviewStatistic`` by its `id`.
    public static func reviewStatistic(_ id: Int) -> Self {
        Self(id: id)
    }
}
