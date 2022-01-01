import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// The response from WaniKani.
@dynamicMemberLookup
public struct Response<R: Resource> {
    public typealias Content = R.Content

    /// The deserialized content of the response from WaniKani.
    public var data: Content
    /// Details of the HTTP response itself, including headers and client information.
    public var response: URLResponse

    init(data: Content, response: URLResponse) {
        self.data = data
        self.response = response
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Content, T>) -> T {
        data[keyPath: keyPath]
    }

    public subscript<T>(dynamicMember keyPath: WritableKeyPath<Content, T>) -> T {
        get { data[keyPath: keyPath] }
        set { data[keyPath: keyPath] = newValue }
    }
}

/// Errors pertaining to issues inherent to the response from WaniKani.
public enum ResponseError: Swift.Error {
    /// The response from WaniKani was not in an understood format.
    case incompatibleResponse(URLResponse)
    /// This is thrown when WaniKani receives an error pertaining to rate limiting.
    case rateLimitExceeded(limit: Int, remaining: Int, reset: Date)
}

/// HTTP response codes returned by WaniKani.
public enum StatusCode: Int, Error, Codable {
    /// The request was successfully processed.
    case ok = 200
    /// The request was successful but did not return any data because it should be cached.
    case notModified = 304
    /// The necessary authentication credentials are not present in the request or are incorrect.
    case unauthorized = 401
    /// The server is refusing to respond to the request.
    case forbidden = 403
    /// The requested resource was not found but could be available again in the future.
    case notFound = 404
    /// The request body was well-formed but contains semantic errors. The response body will provide more details in the errors or error parameters.
    case unprocessableEntity = 422
    /// The request was not accepted because the application has exceeded the rate limit.
    case tooManyRequests = 429
    /// An internal error occurred in WaniKani.
    case internalServerError = 500
    /// The server is currently unavailable. Check the status page or WaniKani Forums for reported service outages.
    case serviceUnavailable = 503

    /// Whether the status code is known to be successful.
    var isSuccess: Bool {
        self == .ok ||
        self == .notModified
    }
}
