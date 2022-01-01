import Foundation
@testable import WaniKani

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct MockResources {
    struct Body: Codable, Equatable {
        var name: String
        var age: Int
    }

    struct Content: Codable, Equatable {
        var name: String
        var age: Int
    }

    struct HasContent: Resource {
        typealias Content = MockResources.Content
        let path = "mock"
    }

    var contentResource = HasContent()
    var content = HasContent.Content(name: "Jeff", age: 35)

    struct HasBodyAndContent: Resource {
        typealias Content = MockResources.Content

        var body: MockResources.Body
        let path = "mock"
    }

    var bodyAndContentResource = HasBodyAndContent(body: HasBodyAndContent.Body(name: "Jeff", age: 35))
    var bodyAndContent = HasBodyAndContent.Content(name: "Jeff", age: 35)
}

enum MockData {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .custom(Formatters.encodeISO8601)
        return encoder
    }()
}

extension MockData {
    static func mockingSuccess<Content: Codable>(with content: Content, url: URL) throws -> (Data, URLResponse) {
        let data = try encoder.encode(content)
        return (data, urlResponse(for: url, status: .ok))
    }

    static func mockingSuccess(for request: URLRequest) throws -> (Data, URLResponse) {
        guard let url = request.url else {
            fatalError("No URL was present on the request")
        }
        let content = MockResources.HasBodyAndContent.Body(name: "Jeff", age: 35)
        return try mockingSuccess(with: content, url: url)
    }

    static func mockingIncompatibleResponse(for url: URL) -> (Data, URLResponse) {
        return (Data(), urlResponse(for: url, rawStatus: -128))
    }

    static func mockingUnsuccessfulResponse(for url: URL) -> (Data, URLResponse) {
        let json = #"{"message":"not found","errors": ["go away"]}"#
        guard let data = json.data(using: .utf8) else {
            fatalError("Could not encode json as data")
        }
        return (data, urlResponse(for: url, status: .notFound))
    }

    static func mockingError(for request: URLRequest) throws -> (Data, URLResponse) {
        throw URLError(.notConnectedToInternet)
    }

    static func mockingError(_ error: Error) throws -> (Data, URLResponse) {
        throw error
    }

    private static func urlResponse(for url: URL, status: StatusCode) -> URLResponse {
        urlResponse(for: url, rawStatus: status.rawValue)
    }

    private static func urlResponse(for url: URL, rawStatus status: Int) -> URLResponse {
        HTTPURLResponse(url: url,
                        statusCode: status,
                        httpVersion: "HTTP/1.1",
                        headerFields: [:])!
    }
}
