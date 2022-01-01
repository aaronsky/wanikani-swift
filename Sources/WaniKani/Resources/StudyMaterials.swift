import Foundation

public enum StudyMaterials {
    /// Returns a collection of all ``StudyMaterial``s, ordered by ascending creation date, 500 at a time.
    public struct List: Resource {
        public typealias Content = ModelCollection<StudyMaterial>

        public let path = "study_materials"

        /// Return study materials with a matching value in the ``StudyMaterial/isHidden`` attribute.
        var isHidden: Bool?
        /// Only study materials where `id` matches one of the array values are returned.
        var ids: [Int]?
        /// Only review statistics where ``StudyMaterial/subjectID`` matches one of the array values are returned.
        var subjectIDs: [Int]?
        /// Only study materials where ``StudyMaterial/subjectType`` matches one of the array values are returned.
        var subjectTypes: [Subject.Kind]?
        /// Only study materials updated after this time are returned.
        var updatedAfter: Date?

        public func transformRequest(_ request: inout URLRequest) {
            guard let url = request.url,
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                      return
                  }

            var queryItems: [URLQueryItem] = []

            queryItems.appendIfNeeded(isHidden, forKey: "hidden")
            queryItems.appendIfNeeded(ids, forKey: "ids")
            queryItems.appendIfNeeded(subjectIDs, forKey: "subject_ids")
            queryItems.appendIfNeeded(subjectTypes, forKey: "subject_types")
            queryItems.appendIfNeeded(updatedAfter, forKey: "updated_after")
            components.queryItems = queryItems
            request.url = components.url
        }
    }

    /// Retrieves a specific ``StudyMaterial`` by its `id`.
    public struct Get: Resource {
        public typealias Content = StudyMaterial

        /// Unique identifier of the ``StudyMaterial``.
        public var id: Int

        public var path: String {
            "study_materials/\(id)"
        }
    }

    /// Creates a ``StudyMaterial`` for a specific subject `id`.
    ///
    /// The owner of the api key can only create one ``StudyMaterial`` per subject `id`.
    public struct Create: Resource {
        public typealias Content = StudyMaterial

        public var body: Body

        public struct Body: Codable {
            /// Unique identifier of the subject.
            var subjectID: Int
            /// Meaning notes specific for the subject.
            var meaningNote: String?
            /// Reading notes specific for the subject.
            var readingNote: String?
            /// Meaning synonyms for the subject.
            var meaningSynonyms: [String]?

            public init(subjectID: Int, meaningNote: String?, readingNote: String?, meaningSynonyms: [String]?) {
                self.subjectID = subjectID
                self.meaningNote = meaningNote
                self.readingNote = readingNote
                self.meaningSynonyms = meaningSynonyms
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let body = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .studyMaterial)
                subjectID = try body.decode(Int.self, forKey: .subjectID)
                meaningNote = try body.decodeIfPresent(String.self, forKey: .meaningNote)
                readingNote = try body.decode(String.self, forKey: .readingNote)
                meaningSynonyms = try body.decode([String].self, forKey: .meaningSynonyms)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var body = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .studyMaterial)
                try body.encode(subjectID, forKey: .subjectID)
                try body.encodeIfPresent(meaningNote, forKey: .meaningNote)
                try body.encodeIfPresent(readingNote, forKey: .readingNote)
                try body.encodeIfPresent(meaningSynonyms, forKey: .meaningSynonyms)
            }

            private enum CodingKeys: String, CodingKey {
                case studyMaterial = "study_material"
                case subjectID = "subject_id"
                case meaningNote = "meaning_note"
                case readingNote = "reading_note"
                case meaningSynonyms = "meaning_synonyms"
            }
        }

        public let path = "study_materials"

        public func transformRequest(_ request: inout URLRequest) {
            request.httpMethod = "POST"
        }
    }

    /// Updates a ``StudyMaterial`` by its `id`.
    public struct Update: Resource {
        public typealias Content = StudyMaterial

        /// Unique identifier of the ``StudyMaterial``.
        public var id: Int

        public var body: Body

        public struct Body: Codable {
            /// Meaning notes specific for the subject.
            var meaningNote: String?
            /// Reading notes specific for the subject.
            var readingNote: String?
            /// Meaning synonyms for the subject.
            var meaningSynonyms: [String]?

            public init(meaningNote: String?, readingNote: String?, meaningSynonyms: [String]?) {
                self.meaningNote = meaningNote
                self.readingNote = readingNote
                self.meaningSynonyms = meaningSynonyms
            }

            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let body = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .studyMaterial)
                meaningNote = try body.decodeIfPresent(String.self, forKey: .meaningNote)
                readingNote = try body.decode(String.self, forKey: .readingNote)
                meaningSynonyms = try body.decode([String].self, forKey: .meaningSynonyms)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var body = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .studyMaterial)
                try body.encodeIfPresent(meaningNote, forKey: .meaningNote)
                try body.encodeIfPresent(readingNote, forKey: .readingNote)
                try body.encodeIfPresent(meaningSynonyms, forKey: .meaningSynonyms)
            }

            private enum CodingKeys: String, CodingKey {
                case studyMaterial = "study_material"
                case meaningNote = "meaning_note"
                case readingNote = "reading_note"
                case meaningSynonyms = "meaning_synonyms"
            }
        }

        public var path: String {
            "study_materials/\(id)"
        }

        public func transformRequest(_ request: inout URLRequest) {
            request.httpMethod = "PUT"
        }
    }
}

extension Resource where Self == StudyMaterials.List {
    /// Returns a collection of all ``StudyMaterial``s, ordered by ascending creation date, 500 at a time.
    public static func studyMaterials(
        isHidden: Bool? = nil,
        ids: [Int]? = nil,
        subjectIDs: [Int]? = nil,
        subjectTypes: [Subject.Kind]? = nil,
        updatedAfter: Date? = nil
    ) -> Self {
        Self(isHidden: isHidden,
             ids: ids,
             subjectIDs: subjectIDs,
             subjectTypes: subjectTypes,
             updatedAfter: updatedAfter)
    }
}

extension Resource where Self == StudyMaterials.Get {
    /// Retrieves a specific ``StudyMaterial`` by its `id`.
    public static func studyMaterial(_ id: Int) -> Self {
        Self(id: id)
    }
}

extension Resource where Self == StudyMaterials.Create {
    /// Creates a ``StudyMaterial`` for a specific subject `id`.
    public static func createStudyMaterial(
        subjectID: Int,
        meaningNote: String? = nil,
        readingNote: String? = nil,
        meaningSynonyms: [String]? = nil
    ) -> Self {
        Self(body: Self.Body(subjectID: subjectID,
                             meaningNote: meaningNote,
                             readingNote: readingNote,
                             meaningSynonyms: meaningSynonyms))
    }
}

extension Resource where Self == StudyMaterials.Update {
    /// Updates a ``StudyMaterial`` by its `id`.
    public static func updateStudyMaterial(
        _ id: Int,
        meaningNote: String? = nil,
        readingNote: String? = nil,
        meaningSynonyms: [String]? = nil
    ) -> Self {
        Self(id: id, body: Self.Body(meaningNote: meaningNote,
                                     readingNote: readingNote,
                                     meaningSynonyms: meaningSynonyms))
    }
}
