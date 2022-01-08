import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum LevelProgressions {
    /// The collection of ``LevelProgression``s will be filtered on the parameters provided.
    public struct List: Resource {
        public typealias Content = ModelCollection<LevelProgression>

        public let path = "level_progressions"

        /// Only level progressions where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only level progressions updated after this time are returned.
        var updatedAfter: Date?

        public init(
            ids: [Int]? = nil,
            updatedAfter: Date? = nil
        ) {
            self.ids = ids
            self.updatedAfter = updatedAfter
        }

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                return
            }

            var queryItems = components.queryItems ?? []
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``LevelProgression`` by its `id`.
    public struct Get: Resource {
        public typealias Content = LevelProgression

        /// Unique identifier of the level progression.
        public var id: Int

        public init(
            id: Int
        ) {
            self.id = id
        }

        public var path: String {
            "level_progressions/\(id)"
        }
    }
}

extension Resource where Self == LevelProgressions.List {
    /// The collection of ``LevelProgression``s will be filtered on the parameters provided.
    public static func levelProgressions(ids: [Int]? = nil, updatedAfter: Date? = nil) -> Self {
        Self(ids: ids, updatedAfter: updatedAfter)
    }
}

extension Resource where Self == LevelProgressions.Get {
    /// Retrieves a specific ``LevelProgression`` by its `id`.
    public static func levelProgression(_ id: Int) -> Self {
        Self(id: id)
    }
}
