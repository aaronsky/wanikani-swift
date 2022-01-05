import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Subjects {
    /// Returns a collection of all ``Subject``s, ordered by ascending creation date, 1000 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<Subject>

        public let path = "subjects"
        public let cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

        /// Only subjects where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Return subjects of the specified types.
        var types: [String]?
        /// Return subjects of the specified slug.
        var slugs: [String]?
        /// Return subjects at the specified levels.
        var levels: [Int]?
        /// Return subjects which are or are not hidden from the user-facing application.
        var isHidden: Bool?
        /// Only subjects updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else {
                return
            }

            var queryItems = components.queryItems ?? []
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(types, forKey: "types")
            queryItems.appendIfNeeded(slugs, forKey: "slugs")
            queryItems.appendIfNeeded(levels, forKey: "levels")
            queryItems.appendIfNeeded(isHidden, forKey: "hidden")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``Subject`` by its `id`.
    public struct Get: Resource {
        public typealias Content = Subject

        /// Unique identifier of the `subject`.
        public var id: Int
        public let cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad

        public var path: String {
            "subjects/\(id)"
        }
    }
}

extension Resource where Self == Subjects.List {
    /// Returns a collection of all ``Subject``s, ordered by ascending creation date, 1000 at a time.
    public static func subjects(
        ids: [Int]? = nil,
        types: [String]? = nil,
        slugs: [String]? = nil,
        levels: [Int]? = nil,
        isHidden: Bool? = nil,
        updatedAfter: Date? = nil
    ) -> Self {
        Self(
            ids: ids,
            types: types,
            slugs: slugs,
            levels: levels,
            isHidden: isHidden,
            updatedAfter: updatedAfter
        )
    }
}

extension Resource where Self == Subjects.Get {
    /// Retrieves a specific ``Subject`` by its `id`.
    public static func subject(_ id: Int) -> Self {
        Self(id: id)
    }
}
