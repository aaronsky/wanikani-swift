import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum VoiceActors {
    /// Returns a collection of all ``VoiceActor``s, ordered by ascending creation date, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<VoiceActor>

        public let path = "voice_actors"

        /// Only level progressions where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only ``VoiceActor``s updated after this time are returned.
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

    /// Retrieves a specific ``VoiceActor`` by its `id`.
    public struct Get: Resource {
        public typealias Content = VoiceActor

        /// Unique identifier of the assignment.
        public var id: Int

        public init(
            id: Int
        ) {
            self.id = id
        }

        public var path: String {
            "voice_actors/\(id)"
        }
    }
}

extension Resource where Self == VoiceActors.List {
    /// Returns a collection of all ``VoiceActor``s, ordered by ascending creation date, 500 at a time.
    public static func voiceActors(ids: [Int]? = nil, updatedAfter: Date? = nil) -> Self {
        Self(ids: ids, updatedAfter: updatedAfter)
    }
}

extension Resource where Self == VoiceActors.Get {
    /// Retrieves a specific ``VoiceActor`` by its `id`.
    public static func voiceActor(_ id: Int) -> Self {
        Self(id: id)
    }
}
