import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// A client to the WaniKani REST API backend.
public struct WaniKani {
    /// General structure for errors returned by the WaniKani REST API.
    public struct Error: Swift.Error, Decodable, Equatable {
        /// The status code both contained within the error payload and of the response.
        public var statusCode: StatusCode
        /// The unlocalized message from the WaniKani backend
        public var message: String?

        private enum CodingKeys: String, CodingKey {
            case statusCode = "code"
            case message = "error"
        }
    }

    /// Configuration for general interaction with the WaniKani REST API, including access tokens and supported API versions.
    public var configuration: Configuration

    /// The network (or whatever) transport layer. Implemented by URLSession by default.
    private var transport: Transport

    /// Convenience property for setting the access token used by the client.
    public var token: String? {
        get { configuration.token }
        set { configuration.token = newValue }
    }

    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom(Formatters.encodeISO8601)
        return encoder
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(Formatters.decodeISO8601)
        return decoder
    }

    /// Creates a session with the specified configuration and transport layer.
    ///
    /// - Parameters:
    ///   - configuration: Configures supported API versions and the access token.
    ///   - transport: Transport layer used for API communication. Uses the shared URLSession by default.
    public init(
        configuration: Configuration = .default,
        transport: Transport = URLSession.shared
    ) {
        self.transport = transport
        self.configuration = configuration
    }

    /// Sends a resource to WaniKani and responds accordingly.
    ///
    /// - Parameters:
    ///   - resource: The resource object, which describes how to perform the request
    ///   - pageOptions: Options for pagination, which are ignored by resources that do not involve pagination.
    /// - Returns: A ``Response`` object containing the requested payload and associated URLResponse.
    /// - Throws: An error, known to be either from URLSession, JSONDecoder, or a ``Error``.
    public func send<R>(_ resource: R, pageOptions: PageOptions? = nil) async throws -> Response<R>
    where R: Resource, R.Content: Decodable {
        let request = try URLRequest(resource, pageOptions: pageOptions, configuration: configuration)
        return try await send(request: request)
    }

    /// Sends a resource carrying a body to WaniKani and responds accordingly.
    ///
    /// - Parameters:
    ///   - resource: The resource object, which describes how to perform the request
    ///   - pageOptions: Options for pagination, which are ignored by resources that do not involve pagination.
    /// - Returns: A ``Response`` object containing the requested payload and associated URLResponse.
    /// - Throws: An error, known to be either from URLSession, JSONEncoder, JSONDecoder, or a ``Error``.
    public func send<R>(_ resource: R, pageOptions: PageOptions? = nil) async throws -> Response<R>
    where R: Resource, R.Body: Encodable, R.Content: Decodable {
        let request = try URLRequest(resource, pageOptions: pageOptions, configuration: configuration, encoder: encoder)
        return try await send(request: request)
    }

    private func send<R>(request: URLRequest) async throws -> Response<R> where R: Resource, R.Content: Decodable {
        let decoder = self.decoder

        let (data, response) = try await transport.send(request: request)
        try checkResponseForIssues(response, data: data, decoder: decoder)

        let content = try decoder.decode(R.Content.self, from: data)

        return Response(data: content, response: response)
    }

    /// Paginate a collection of resources as an async stream, starting from the given ID (or the beginning of the collection by default). Defaults to waiting on rate limit errors, though this can be disabled.
    ///
    /// - Parameters:
    ///   - resource:The resource object, which describes how to perform each request
    ///   - id: The id to start paginating from. Defaults to `nil`, which will be the beginning of the collection.
    ///   - waitOnRateLimitErrors: Whether or not to Task.sleep upon encountering rate limit errors. Defaults to `true`.
    /// - Returns: An async stream of ``Response`` objects containing the given page's requested payload and associated URLResponse.
    public func paginate<R, Inner>(
        _ resource: R,
        afterID id: Int? = nil,
        waitOnRateLimitErrors: Bool = true
    ) -> AsyncThrowingStream<Response<R>, Swift.Error> where R: Resource, R.Content == ModelCollection<Inner> {
        var isFirstPage = true
        var nextPage: PageOptions?
        if let id = id {
            nextPage = PageOptions(afterID: id)
        }

        return AsyncThrowingStream {
            guard nextPage != nil || (nextPage == nil && isFirstPage) else {
                return nil
            }

            var keepTrying = true

            while keepTrying {
                keepTrying = false

                do {
                    let response = try await self.send(resource, pageOptions: nextPage)
                    isFirstPage = false
                    nextPage = response.page.next

                    return response
                } catch ResponseError.rateLimitExceeded(let rateLimit, let rateRemaining, let rateReset) {
                    guard waitOnRateLimitErrors else {
                        throw ResponseError.rateLimitExceeded(
                            limit: rateLimit,
                            remaining: rateRemaining,
                            reset: rateReset
                        )
                    }
                    try await Task.sleep(nanoseconds: UInt64(rateReset.timeIntervalSinceNow) * NSEC_PER_SEC)
                    keepTrying = true
                } catch {
                    throw error
                }
            }

            return nil
        }
    }

    private func checkResponseForIssues(_ response: URLResponse, data: Data, decoder: JSONDecoder) throws {
        guard let httpResponse = response as? HTTPURLResponse,
            let statusCode = StatusCode(rawValue: httpResponse.statusCode)
        else {
            throw ResponseError.incompatibleResponse(response)
        }

        if !statusCode.isSuccess {
            if statusCode == .tooManyRequests,
                let rawLimit = httpResponse.allHeaderFields["Ratelimit-Limit"] as? String,
                let limit = Int(rawLimit),
                let rawRemaining = httpResponse.allHeaderFields["Ratelimit-Remaining"] as? String,
                let remaining = Int(rawRemaining),
                let rawReset = httpResponse.allHeaderFields["Ratelimit-Reset"] as? String,
                let resetSecondsSinceEpoch = TimeInterval(rawReset)
            {
                let reset = Date(timeIntervalSince1970: resetSecondsSinceEpoch)
                throw ResponseError.rateLimitExceeded(limit: limit, remaining: remaining, reset: reset)
            } else if let error = try? decoder.decode(Error.self, from: data) {
                throw error
            } else {
                throw statusCode
            }
        }
    }
}
