import Foundation

public enum Resets {
    /// Returns a collection of all ``Reset``s, ordered by ascending creation date, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<Reset>

        public let path = "resets"

        /// Only resets where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only resets updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                      return
                  }

            var queryItems: [URLQueryItem] = []

            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``Reset`` by its `id`.
    public struct Get: Resource {
        public typealias Content = Reset

        /// Unique identifier of the reset.
        public var id: Int

        public var path: String {
            "resets/\(id)"
        }
    }
}

extension Resource where Self == Resets.List {
    /// Returns a collection of all ``Reset``s, ordered by ascending creation date, 500 at a time.
    public static func resets(ids: [Int]? = nil, updatedAfter: Date? = nil) -> Self {
        Self(ids: ids, updatedAfter: updatedAfter)
    }
}

extension Resource where Self == Resets.Get {
    /// Retrieves a specific ``Reset`` by its `id`.
    public static func reset(_ id: Int) -> Self {
        Self(id: id)
    }
}
