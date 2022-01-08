import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum Users {
    /// Returns a summary of user information for the currently authenticated user.
    public struct Me: Resource {
        public typealias Content = User

        public let path = "user"

        public init() {}
    }

    /// Returns an updated summary of user information.
    public struct Update: Resource {
        public typealias Content = User

        public var body: Body

        /// Only the values under `preferences` are allowed to be updated.
        public struct Body: Codable {
            var defaultVoiceActorID: Int?
            var lessonsAutoplayAudio: Bool?
            var lessonsBatchSize: Int?
            var lessonsPresentationOrder: User.Preferences.PresentationOrder?
            var reviewsAutoplayAudio: Bool?
            var reviewsDisplaySRSIndicator: Bool?

            public init(
                defaultVoiceActorID: Int? = nil,
                lessonsAutoplayAudio: Bool? = nil,
                lessonsBatchSize: Int? = nil,
                lessonsPresentationOrder: User.Preferences.PresentationOrder? = nil,
                reviewsAutoplayAudio: Bool? = nil,
                reviewsDisplaySRSIndicator: Bool? = nil
            ) {
                self.defaultVoiceActorID = defaultVoiceActorID
                self.lessonsAutoplayAudio = lessonsAutoplayAudio
                self.lessonsBatchSize = lessonsBatchSize
                self.lessonsPresentationOrder = lessonsPresentationOrder
                self.reviewsAutoplayAudio = reviewsAutoplayAudio
                self.reviewsDisplaySRSIndicator = reviewsDisplaySRSIndicator
            }

            public init(
                from decoder: Decoder
            ) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                let body = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
                defaultVoiceActorID = try body.decodeIfPresent(Int.self, forKey: .defaultVoiceActorID)
                lessonsAutoplayAudio = try body.decodeIfPresent(Bool.self, forKey: .lessonsAutoplayAudio)
                lessonsBatchSize = try body.decodeIfPresent(Int.self, forKey: .lessonsBatchSize)
                lessonsPresentationOrder = try body.decodeIfPresent(
                    User.Preferences.PresentationOrder.self,
                    forKey: .lessonsPresentationOrder
                )
                reviewsAutoplayAudio = try body.decodeIfPresent(Bool.self, forKey: .reviewsAutoplayAudio)
                reviewsDisplaySRSIndicator = try body.decodeIfPresent(Bool.self, forKey: .reviewsDisplaySRSIndicator)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                var user = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
                var preferences = user.nestedContainer(keyedBy: CodingKeys.self, forKey: .preferences)
                try preferences.encodeIfPresent(defaultVoiceActorID, forKey: .defaultVoiceActorID)
                try preferences.encodeIfPresent(lessonsAutoplayAudio, forKey: .lessonsAutoplayAudio)
                try preferences.encodeIfPresent(lessonsBatchSize, forKey: .lessonsBatchSize)
                try preferences.encodeIfPresent(lessonsPresentationOrder, forKey: .lessonsPresentationOrder)
                try preferences.encodeIfPresent(reviewsAutoplayAudio, forKey: .reviewsAutoplayAudio)
                try preferences.encodeIfPresent(reviewsDisplaySRSIndicator, forKey: .reviewsDisplaySRSIndicator)
            }

            private enum CodingKeys: String, CodingKey {
                case user
                case preferences
                case defaultVoiceActorID = "default_voice_actor_id"
                case lessonsAutoplayAudio = "lessons_autoplay_audio"
                case lessonsBatchSize = "lessons_batch_size"
                case lessonsPresentationOrder = "lessons_presentation_order"
                case reviewsAutoplayAudio = "reviews_autoplay_audio"
                case reviewsDisplaySRSIndicator = "reviews_display_srs_indicator"
            }
        }

        public let path = "user"

        public init(
            body: Body
        ) {
            self.body = body
        }

        public func transformRequest(_ request: inout URLRequest) {
            request.httpMethod = "PUT"
        }
    }
}

extension Resource where Self == Users.Me {
    /// Returns a summary of user information for the currently authenticated user.
    public static var me: Self {
        Self()
    }
}

extension Resource where Self == Users.Update {
    /// Returns an updated summary of user information.
    public static func updateUser(
        defaultVoiceActorID: Int? = nil,
        lessonsAutoplayAudio: Bool? = nil,
        lessonsBatchSize: Int? = nil,
        lessonsPresentationOrder: User.Preferences.PresentationOrder? = nil,
        reviewsAutoplayAudio: Bool? = nil,
        reviewsDisplaySRSIndicator: Bool? = nil
    ) -> Self {
        Self(
            body: Self.Body(
                defaultVoiceActorID: defaultVoiceActorID,
                lessonsAutoplayAudio: lessonsAutoplayAudio,
                lessonsBatchSize: lessonsBatchSize,
                lessonsPresentationOrder: lessonsPresentationOrder,
                reviewsAutoplayAudio: reviewsAutoplayAudio,
                reviewsDisplaySRSIndicator: reviewsDisplaySRSIndicator
            )
        )
    }

    /// Helper method for updating all properties for a user's preferences using
    /// an existing ``Preferences`` instance.
    ///
    /// - Parameter preferences: A ``Preferences`` object from an existing ``User`` object.
    /// - Returns: An updated summary of user information.
    public static func updateUser(preferences: User.Preferences) -> Self {
        Self(
            body: Self.Body(
                defaultVoiceActorID: preferences.defaultVoiceActorID,
                lessonsAutoplayAudio: preferences.autoplayLessonsAudio,
                lessonsBatchSize: preferences.lessonsBatchSize,
                lessonsPresentationOrder: preferences.lessonsPresentationOrder,
                reviewsAutoplayAudio: preferences.autoplayReviewsAudio,
                reviewsDisplaySRSIndicator: preferences.displayReviewsSRSIndicator
            )
        )
    }
}
