import Foundation

public enum Summaries {
    /// Retrieves a summary report.
    public struct Get: Resource {
        public typealias Content = Summary

        public let path = "summary"
    }
}

extension Resource where Self == Summaries.Get {
    /// Retrieves a summary report.
    public static var summary: Self {
        Self()
    }
}
