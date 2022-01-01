import Foundation

/// Position in the collection's pagination.
public struct Page: Codable, Equatable {
    /// Maximum number of results delivered for a single page in the collection.
    public var perPageCount: Int
    /// The URL of the previous page of results.
    public var nextURL: URL?
    /// The URL of the previous page of results.
    public var previousURL: URL?

    /// A convenience property to create options for the next page from ``nextURL``.
    public var next: PageOptions? {
        guard let nextURL = nextURL else {
            return nil
        }

        return PageOptions(url: nextURL)
    }

    /// A convenience property to create options for the previous page for continued querying from ``previousURL``.
    public var previous: PageOptions? {
        guard let previousURL = previousURL else {
            return nil
        }

        return PageOptions(url: previousURL)
    }

    init(perPageCount: Int, nextURL: URL? = nil, previousURL: URL? = nil) {
        self.perPageCount = perPageCount
        self.nextURL = nextURL
        self.previousURL = previousURL
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        perPageCount = try container.decode(Int.self, forKey: .perPageCount)
        nextURL = try container.decodeIfPresent(URL.self, forKey: .nextURL)
        previousURL = try container.decodeIfPresent(URL.self, forKey: .previousURL)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(perPageCount, forKey: .perPageCount)
        try container.encode(nextURL, forKey: .nextURL)
        try container.encode(previousURL, forKey: .previousURL)
    }

    enum CodingKeys: String, CodingKey {
        case perPageCount = "per_page"
        case nextURL = "next_url"
        case previousURL = "previous_url"
    }
}

/// Paging options used for pagination.
public struct PageOptions: Equatable {
    /// The ID after which to continue pagination.
    public var id: Int

    public init(afterID id: Int) {
        self.id = id
    }

    init?(url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let item = components
                .queryItems?
                .first(where: {
                    $0.name == QueryItemKeys.pageAfterID.rawValue
                }),
              let rawID = item.value,
              let id = Int(rawID) else {
                  return nil
              }

        self.init(afterID: id)
    }

    enum QueryItemKeys: String, CaseIterable {
        case pageAfterID = "page_after_id"
    }
}

extension URLRequest {
    mutating func appendPageOptions(_ options: PageOptions) {
        guard let url = self.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                  return
              }

        var queryItems = components.queryItems ?? []
        queryItems.append(pageOptions: options)
        components.queryItems = queryItems

        self.url = components.url
    }
}

private extension Array where Element == URLQueryItem {
    mutating func append(pageOptions: PageOptions) {
        append(URLQueryItem(name: PageOptions.QueryItemKeys.pageAfterID.rawValue, value: String(pageOptions.id)))
    }
}
