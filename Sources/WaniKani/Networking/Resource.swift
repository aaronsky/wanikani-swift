import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Defines a request to WaniKani.
public protocol Resource {
    /// The data the resource is expected to send alongside.
    associatedtype Body = Void
    /// The data the resource is expected to respond with.
    associatedtype Content = Void

    /// Resource path. Relative to the metadata within ``WaniKani/WaniKani/Configuration-swift.struct``.
    var path: String { get }
    /// The body of the resource instance. Only used with non-GET resources.
    var body: Body { get }
    /// The cache policy of the resource. Determines how aggressively to cache the response data.
    var cachePolicy: URLRequest.CachePolicy { get }

    /// A helper for resources to transform the content of their requests. Common use-cases are for appending
    /// query items and altering HTTP methods.
    ///
    /// - Parameter request: The request to transform.
    func transformRequest(_ request: inout URLRequest)
}

extension Resource {
    public var cachePolicy: URLRequest.CachePolicy {
        .useProtocolCachePolicy
    }

    public func transformRequest(_ request: inout URLRequest) {}
}

extension Resource where Body == Void {
    public var body: Body {
        ()
    }
}

extension URLRequest {
    static let applicationJSONHeaderValue = "application/json; charset=utf-8"

    init<R: Resource>(
        _ resource: R,
        pageOptions: PageOptions?,
        configuration: WaniKani.Configuration
    ) throws {
        let url = configuration
            .version
            .url(for: resource.path)

        var request = Self(url: url)

        request.cachePolicy = resource.cachePolicy

        if let options = pageOptions {
            request.appendPageOptions(options)
        }

        configuration.transformRequest(&request)
        resource.transformRequest(&request)

        self = request
    }

    init<R: Resource>(
        _ resource: R,
        pageOptions: PageOptions?,
        configuration: WaniKani.Configuration,
        encoder: JSONEncoder
    ) throws where R.Body: Encodable {
        try self.init(resource, pageOptions: pageOptions, configuration: configuration)
        addValue(Self.applicationJSONHeaderValue, forHTTPHeaderField: "Content-Type")
        httpBody = try encoder.encode(resource.body)
    }
}
