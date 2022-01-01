import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Array where Element == URLQueryItem {
    mutating func appendIfNeeded<S: RawRepresentable>(_ value: S?, forKey key: String) where S.RawValue: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(URLQueryItem(name: key, value: String(value.rawValue)))
    }

    mutating func appendIfNeeded<S: LosslessStringConvertible>(_ value: S?, forKey key: String) {
        guard let value = value else {
            return
        }

        append(URLQueryItem(name: key, value: String(value)))
    }

    mutating func appendIfNeeded<S>(_ value: S?, forKey key: String) where S: Collection, S.Element: RawRepresentable, S.Element.RawValue: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value.map(\.rawValue), forKey: key)
    }

    mutating func appendIfNeeded<S>(_ value: S?, forKey key: String) where S: Collection, S.Element: LosslessStringConvertible {
        guard let value = value else {
            return
        }

        append(value, forKey: key)
    }

    mutating func append<S>(_ items: S, forKey key: String) where S: Collection, S.Element: LosslessStringConvertible {
        let value = items
            .map(String.init)
            .joined(separator: ",")

        if value.isEmpty {
            return
        }

        append(URLQueryItem(name: key, value: value))
    }
}

extension Date: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let date = Formatters.iso8601.date(from: description) else {
            return nil
        }

        self = date
    }
}

extension UUID: LosslessStringConvertible {
    public init?(_ description: String) {
        guard let id = UUID(uuidString: description) else {
            return nil
        }

        self = id
    }
}
