import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum SpacedRepetitionSystems {
    /// Returns a collection of all ``SpacedRepetitionSystem``, ordered by ascending `id`, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<SpacedRepetitionSystem>

        public let path = "spaced_repetition_systems"

        /// Only ``SpacedRepetitionSystem`` where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only ``SpacedRepetitionSystem``s updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                      return
                  }

            var queryItems = components.queryItems ?? []
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``SpacedRepetitionSystem`` by its `id`.
    public struct Get: Resource {
        public typealias Content = SpacedRepetitionSystem

        /// Unique identifier of the ``SpacedRepetitionSystem``.
        public var id: Int

        public var path: String {
            "spaced_repetition_systems/\(id)"
        }
    }
}

extension Resource where Self == SpacedRepetitionSystems.List {
    /// Returns a collection of all ``SpacedRepetitionSystem``, ordered by ascending `id`, 500 at a time.
    public static func spacedRepetitionSystems(ids: [Int]? = nil, updatedAfter: Date? = nil) -> Self {
        Self(ids: ids, updatedAfter: updatedAfter)
    }
}

extension Resource where Self == SpacedRepetitionSystems.Get {
    /// Retrieves a specific ``SpacedRepetitionSystem`` by its `id`.
    public static func spacedRepetitionSystem(_ id: Int) -> Self {
        Self(id: id)
    }
}
