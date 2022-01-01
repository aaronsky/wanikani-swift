import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// An abstraction of the transport layer. URLSession provides a default implementation for network transport.
public protocol Transport {
    typealias Output = (data: Data, response: URLResponse)

    /// Send the given request and asynchronously retrieve the output.
    func send(request: URLRequest) async throws -> Output
}

extension URLSession: Transport {
    public func send(request: URLRequest) async throws -> Output {
        try await data(for: request)
    }
}
