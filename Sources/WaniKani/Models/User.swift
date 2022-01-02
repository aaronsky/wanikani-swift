import Foundation

/// The user summary returns basic information for the user making the API request, identified by their API key.
public struct User: ModelProtocol {
    public let object = "user"

    /// If the user is on vacation, this will be the timestamp of when that vacation started. If the user is not on vacation, this is `null`.
    public var currentVacationStarted: Date?
    public var id: UUID
    public var lastUpdated: Date?
    /// The current level of the user. This ignores subscription status.
    public var level: Int
    /// User settings specific to the WaniKani application.
    public var preferences: Preferences
    /// The URL to the user's public facing profile page.
    public var profileURL: URL
    /// The signup date for the user.
    public var started: Date
    /// Details about the user's subscription state.
    public var subscription: Subscription
    /// The user's username.
    public var username: String
    public var url: URL

    init(
        currentVacationStarted: Date? = nil,
        id: UUID,
        lastUpdated: Date? = nil,
        level: Int,
        preferences: User.Preferences,
        profileURL: URL,
        started: Date,
        subscription: User.Subscription,
        username: String,
        url: URL
    ) {
        self.currentVacationStarted = currentVacationStarted
        self.id = id
        self.lastUpdated = lastUpdated
        self.level = level
        self.preferences = preferences
        self.profileURL = profileURL
        self.started = started
        self.subscription = subscription
        self.username = username
        self.url = url
    }

    public init(from decoder: Decoder) throws {
        let modelContainer = try decoder.container(keyedBy: ModelCodingKeys.self)

        let object = try modelContainer.decode(String.self, forKey: .object)
        guard object == self.object else {
            throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                              debugDescription: "Expected to decode \(self.object) but found object with resource type \(object)"))
        }

        lastUpdated = try modelContainer.decodeIfPresent(Date.self, forKey: .lastUpdated)
        url = try modelContainer.decode(URL.self, forKey: .url)

        let container = try modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)

        currentVacationStarted = try container.decodeIfPresent(Date.self, forKey: .currentVacationStarted)
        id = try container.decode(UUID.self, forKey: .id)
        level = try container.decode(Int.self, forKey: .level)
        preferences = try container.decode(Preferences.self, forKey: .preferences)
        profileURL = try container.decode(URL.self, forKey: .profileURL)
        started = try container.decode(Date.self, forKey: .started)
        subscription = try container.decode(Subscription.self, forKey: .subscription)
        username = try container.decode(String.self, forKey: .username)
    }

    public func encode(to encoder: Encoder) throws {
        var modelContainer = encoder.container(keyedBy: ModelCodingKeys.self)

        try modelContainer.encode(object, forKey: .object)
        try modelContainer.encodeIfPresent(lastUpdated, forKey: .lastUpdated)
        try modelContainer.encode(url, forKey: .url)

        var container = modelContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .data)
        try container.encode(currentVacationStarted, forKey: .currentVacationStarted)
        try container.encode(id, forKey: .id)
        try container.encode(level, forKey: .level)
        try container.encode(preferences, forKey: .preferences)
        try container.encode(profileURL, forKey: .profileURL)
        try container.encode(started, forKey: .started)
        try container.encode(subscription, forKey: .subscription)
        try container.encode(username, forKey: .username)
    }

    /// User's preferences for WaniKani behavior. Clients should use these where relevant to ensure consistency in the WaniKani experience.
    public struct Preferences: Codable, Equatable {
        /// Automatically play pronunciation audio for vocabulary during lessons.
        public var autoplayLessonsAudio: Bool
        /// Automatically play pronunciation audio for vocabulary during reviews.
        public var autoplayReviewsAudio: Bool
        /// The voice actor to be used for lessons and reviews. The value is associated to ``Vocabulary/PronunciationAudio/Metadata-swift.struct/voiceActorID``.
        public var defaultVoiceActorID: Int
        /// Toggle for display SRS change indicator after a subject has been completely answered during review.
        public var displayReviewsSRSIndicator: Bool
        /// Number of subjects introduced to the user during lessons before quizzing.
        public var lessonsBatchSize: Int
        /// The order in which lessons are presented. The options are ``PresentationOrder/ascendingLevelThenSubject``, ``PresentationOrder/shuffled``, and ``PresentationOrder/ascendingLevelThenShuffled``.
        ///
        /// The default (and best experience) is ``PresentationOrder/ascendingLevelThenSubject``.
        public var lessonsPresentationOrder: PresentationOrder

        public enum PresentationOrder: String, Codable, Equatable {
            case ascendingLevelThenSubject = "ascending_level_then_subject"
            case shuffled
            case ascendingLevelThenShuffled = "ascending_level_then_shuffled"
        }

        private enum CodingKeys: String, CodingKey {
            case autoplayLessonsAudio = "lessons_autoplay_audio"
            case autoplayReviewsAudio = "reviews_autoplay_audio"
            case defaultVoiceActorID = "default_voice_actor_id"
            case displayReviewsSRSIndicator = "reviews_display_srs_indicator"
            case lessonsBatchSize = "lessons_batch_size"
            case lessonsPresentationOrder = "lessons_presentation_order"
        }
    }

    /// Subscription status
    public struct Subscription: Codable, Equatable {
        /// Whether or not the user currently has a paid subscription.
        public var isActive: Bool
        /// The maximum level of content accessible to the user for lessons, reviews, and content review. For unsubscribed/free users, the maximum level is `3`. For subscribed users, this is `60`. **Any application that uses data from the WaniKani API must respect these access limits.**
        public var maxLevelGranted: Int
        /// The date when the user's subscription period ends. If the user has subscription type ``Kind/lifetime`` or ``Kind/free`` then the value is `null`.
        public var periodEnds: Date?
        /// The type of subscription the user has. Options are following: `free`, `recurring`, and `lifetime`.
        public var type: Kind

        /// The kind of subscription
        public enum Kind: String, Codable, Equatable {
            /// The user subscription state isn't known. This is a weird state on WaniKani, should be treated as ``free``, and reported to the WaniKani developers.
            case unknown
            /// Represents people who've never subscribed or have an inactive subscription, so it isn't really a subscription. There's no ``User/Subscription-swift.struct/periodEnds`` for free subscriptions.
            case free
            /// Renew on a periodic basis. ``User/Subscription-swift.struct/periodEnds`` tells you when the subscription renews or expires. Since we give people access until the end of their subscription period even if they cancel, you can generally not check their subscription status until that time.
            case recurring
            /// The user can access WaniKani forever. ``User/Subscription-swift.struct/periodEnds`` is `null`. It's possible that a lifetime user will ask for a refund or have payment difficulties, so scheduled checks on the subscription status are still needed.
            case lifetime
        }

        private enum CodingKeys: String, CodingKey {
            case isActive = "active"
            case maxLevelGranted = "max_level_granted"
            case periodEnds = "period_ends_at"
            case type
        }
    }

    private enum CodingKeys: String, CodingKey {
        case currentVacationStarted = "current_vacation_started_at"
        case id
        case level
        case preferences
        case profileURL = "profile_url"
        case started = "started_at"
        case subscription
        case username
    }
}
