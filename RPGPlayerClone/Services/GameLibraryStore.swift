import Foundation

final class GameLibraryStore: @unchecked Sendable {
    static let shared = GameLibraryStore()

    private let fileManager = FileManager.default

    private init() {}

    private var libraryFileURL: URL {
        FileManager.documentsDirectory
            .appendingPathComponent("LibraryMetadata", isDirectory: true)
            .appendingPathComponent("games.json")
    }

    private var gamesDirectoryURL: URL {
        FileManager.documentsDirectory
            .appendingPathComponent("Games", isDirectory: true)
    }

    func loadGames() -> [Game] {
        guard let data = try? Data(contentsOf: libraryFileURL) else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Game].self, from: data)
        } catch {
            return []
        }
    }

    func saveGames(_ games: [Game]) throws {
        let parent = libraryFileURL.deletingLastPathComponent()
        try fileManager.createDirectoryIfNeeded(at: parent)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let data = try encoder.encode(games)
        try data.write(to: libraryFileURL, options: [.atomic])
    }

    func makeGame(from directory: URL) -> Game {
        makeGame(from: directory, preserving: nil)
    }

    func makeGame(from directory: URL, preserving existing: Game?) -> Game {
        let gameRoot = GameDetector.normalizedGameRoot(from: directory)
        let detectedType = GameType.detect(from: gameRoot)
        let preservedName = existing?.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let engineOverride = normalizedEngineOverride(existing?.engineOverride, for: detectedType)

        return Game(
            id: existing?.id ?? UUID(),
            name: preservedName?.isEmpty == false ? preservedName! : prettifiedName(from: gameRoot.lastPathComponent),
            path: gameRoot,
            coverImage: GameDetector.bestEffortCoverImage(in: gameRoot),
            gameType: detectedType,
            engineOverride: engineOverride,
            lastPlayed: existing?.lastPlayed
        )
    }

    func rescanGames(preserving existingGames: [Game]) -> [Game] {
        try? fileManager.createDirectoryIfNeeded(at: gamesDirectoryURL)

        var existingByPath: [String: Game] = [:]
        for game in existingGames {
            existingByPath[game.path.standardizedFileURL.path] = game
        }

        let items = (try? fileManager.contentsOfDirectory(
            at: gamesDirectoryURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )) ?? []

        var discovered: [Game] = []
        var seenPaths = Set<String>()

        for item in items {
            guard (try? item.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true else {
                continue
            }

            let gameRoot = GameDetector.normalizedGameRoot(from: item).standardizedFileURL
            let normalizedPath = gameRoot.path

            guard seenPaths.insert(normalizedPath).inserted else {
                continue
            }

            guard fileManager.itemExists(at: gameRoot) else {
                continue
            }

            let existing = existingByPath[normalizedPath]
            discovered.append(makeGame(from: gameRoot, preserving: existing))
        }

        return discovered
    }

    private func prettifiedName(from raw: String) -> String {
        raw
            .replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func normalizedEngineOverride(_ engineOverride: GameEngineRuntime?, for gameType: GameType) -> GameEngineRuntime? {
        guard let engineOverride else {
            return nil
        }

        return engineOverride.supports(gameType) ? engineOverride : nil
    }
}
