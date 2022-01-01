import Foundation

/// Shared properties between all top-level model types.
public protocol ModelProtocol: Codable, Equatable {
    /// The kind of object returned. See the object types section below for all the kinds.
    var object: String { get }

    /// The URL of the request. For collections, that will contain all the filters and options you've passed to the API.
    /// Resources have a single URL and don't need to be filtered, so the URL will be the same in both resource
    /// and collection responses.
    var url: URL { get }

    /// For collections, this is the timestamp of the most recently updated resource in the specified scope and is
    /// not limited by pagination. If no resources were returned for the specified scope, then this will be null.
    /// For a resource, then this is the last time that particular resource was updated.
    var lastUpdated: Date? { get }

    /// Resource ID
    var id: Int { get }
}

enum ModelCodingKeys: String, CodingKey {
    case object
    case lastUpdated = "data_updated_at"
    case url
    case data
    case id
}

/// A paged collection of models.
public struct ModelCollection<Model: ModelProtocol>: ModelProtocol, Collection {
    public typealias Element = Model
    public typealias Index = Array<Model>.Index

    public let object = "collection"
    public let id: Int = 0

    public var url: URL
    public var lastUpdated: Date?
    public var totalCount: Int
    public var page: Page
    private var elements: [Element]

    public var startIndex: Index {
        elements.startIndex
    }

    public var endIndex: Index {
        elements.endIndex
    }

    init(url: URL, lastUpdated: Date? = nil, totalCount: Int, page: Page, elements: [Element]) {
        self.url = url
        self.lastUpdated = lastUpdated
        self.totalCount = totalCount
        self.page = page
        self.elements = elements
    }

    public init(from decoder: Decoder) throws {
        let modelContainer = try decoder.container(keyedBy: ModelCodingKeys.self)

        let object = try modelContainer.decode(String.self, forKey: .object)
        guard object == self.object else {
            throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                              debugDescription: "Expected to decode \(self.object) but found object with resource type \(object)"))
        }

        url = try modelContainer.decode(URL.self, forKey: .url)
        lastUpdated = try modelContainer.decodeIfPresent(Date.self, forKey: .lastUpdated)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        page = try container.decode(Page.self, forKey: .page)

        elements = try modelContainer.decode([Element].self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)
        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encode(url, forKey: .url)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)

        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(totalCount, forKey: .totalCount)
        try container.encode(page, forKey: .page)

        try modelContainer.encode(elements, forKey: .data)
    }

    public subscript(index: Index) -> Element {
        elements[index]
    }

    public func index(after i: Index) -> Index {
        return elements.index(after: i)
    }

    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case page = "pages"
    }
}
