import Foundation

struct Game: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var path: URL
    var coverImage: URL?
    var gameType: GameType
    var engineOverride: GameEngineRuntime?
    var lastPlayed: Date?

    init(
        id: UUID = UUID(),
        name: String,
        path: URL,
        coverImage: URL? = nil,
        gameType: GameType = .unknown,
        engineOverride: GameEngineRuntime? = nil,
        lastPlayed: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.path = path
        self.coverImage = coverImage
        self.gameType = gameType
        self.engineOverride = engineOverride
        self.lastPlayed = lastPlayed
    }

    var isPlayable: Bool {
        effectiveEngine != nil
    }

    var sandboxFriendlyPath: URL {
        path.standardizedFileURL
    }

    var effectiveEngine: GameEngineRuntime? {
        if let engineOverride, engineOverride.supports(gameType) {
            return engineOverride
        }

        return gameType.defaultEngineRuntime
    }

    var engineSummary: String {
        if let engineOverride {
            return "Manual: \(engineOverride.displayName)"
        }

        return "Auto: \(gameType.preferredEngineName)"
    }
}
