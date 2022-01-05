import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Array where Element == URLQueryItem {
    mutating func append(
        _ value: String,
        forKey key: String
    ) {
        append(URLQueryItem(name: key, value: value))
    }
    // MARK: LosslessStringConvertible

    mutating func append<S: LosslessStringConvertible>(
        _ value: S,
        forKey key: String
    ) {
        append(String(value), forKey: key)
    }

    mutating func appendIfNeeded<Wrapped>(
        _ value: Optional<Wrapped>,
        forKey key: String
    ) where Wrapped: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    // MARK: RawRepresentable

    mutating func append<S>(
        _ value: S,
        forKey key: String
    ) where S: RawRepresentable, S.RawValue: LosslessStringConvertible {
        append(value.rawValue, forKey: key)
    }

    mutating func appendIfNeeded<Wrapped>(
        _ value: Optional<Wrapped>,
        forKey key: String
    ) where Wrapped: RawRepresentable, Wrapped.RawValue: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    // MARK: Collections

    mutating func append<S>(
        _ items: S,
        forKey key: String
    ) where S: Collection, S.Element: LosslessStringConvertible {
        let value = items
            .map(String.init)
            .joined(separator: ",")

        if value.isEmpty {
            return
        }

        append(String(value), forKey: key)
    }

    mutating func appendIfNeeded<Wrapped>(
        _ value: Optional<Wrapped>,
        forKey key: String
    ) where Wrapped: Collection, Wrapped.Element: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    mutating func append<S>(
        _ items: S,
        forKey key: String
    ) where S: Collection, S.Element: RawRepresentable, S.Element.RawValue: LosslessStringConvertible {
        append(items.map(\.rawValue), forKey: key)
    }

    mutating func appendIfNeeded<Wrapped>(
        _ value: Optional<Wrapped>,
        forKey key: String
    ) where Wrapped: Collection, Wrapped.Element: RawRepresentable, Wrapped.Element.RawValue: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    // MARK: Date

    mutating func append(_ value: Date, forKey key: String) {
        append(value.formatted(.iso8601), forKey: key)
    }

    mutating func appendIfNeeded(_ value: Date?, forKey key: String) {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    // MARK: UUID

    mutating func append(_ value: UUID, forKey key: String) {
        append(value.uuidString, forKey: key)
    }

    mutating func appendIfNeeded(_ value: UUID?, forKey key: String) {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }
}
