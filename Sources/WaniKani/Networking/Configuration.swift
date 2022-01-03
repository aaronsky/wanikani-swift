import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension WaniKani {
    /// Configuration for general interaction with the WaniKani REST API, including access tokens and supported API versions.
    public struct Configuration {
        public var version: APIVersion

        var userAgent = "wanikani-swift"
        var token: String?

        public static var `default`: Self {
            Self(version: .v2)
        }

        init(version: APIVersion) {
            self.version = version
        }

        public func transformRequest(_ request: inout URLRequest) {
            request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
            request.setValue(URLRequest.applicationJSONHeaderValue, forHTTPHeaderField: "Accept")
            request.addValue(version.revision, forHTTPHeaderField: "Wanikani-Revision")
            if let token = token {
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
        }
    }

    /// A supported version of the WaniKani API.
    public struct APIVersion {
        /// API version 2, revision 20170710.
        public static let v2: Self = APIVersion(version: "v2", revision: "20170710")

        var baseURL = URL(string: "https://api.wanikani.com")!
        var version: String
        var revision: String

        public init(version: String, revision: String) {
            self.version = version
            self.revision = revision
        }

        func url(for path: String) -> URL {
            let url = baseURL.appendingPathComponent(version)

            guard !path.isEmpty else {
                return url
            }

            return url.appendingPathComponent(path)
        }
    }
}
