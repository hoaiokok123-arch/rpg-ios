import Foundation

enum NativeEngineLaunchContextKey: String {
    case gameId
    case gameName
    case gameType
    case gamePath
    case engineIdentifier
    case runtimePath
    case savesPath
    case cachePath
}

struct NativeEngineLaunchContext {
    let game: Game
    let engineIdentifier: String
    let runtimeDirectory: URL
    let savesDirectory: URL
    let cacheDirectory: URL

    init(game: Game, engineIdentifier: String, fileManager: FileManager = .default) throws {
        self.game = game
        self.engineIdentifier = engineIdentifier

        let gameComponent = Self.sanitizedPathComponent("\(game.name)-\(game.id.uuidString)")
        runtimeDirectory = FileManager.documentsDirectory
            .appendingPathComponent("NativeEngines", isDirectory: true)
            .appendingPathComponent(engineIdentifier, isDirectory: true)
            .appendingPathComponent(gameComponent, isDirectory: true)

        savesDirectory = runtimeDirectory.appendingPathComponent("Save", isDirectory: true)
        cacheDirectory = FileManager.cachesDirectory
            .appendingPathComponent("NativeEngines", isDirectory: true)
            .appendingPathComponent(engineIdentifier, isDirectory: true)
            .appendingPathComponent(game.id.uuidString, isDirectory: true)

        try fileManager.createDirectoryIfNeeded(at: runtimeDirectory)
        try fileManager.createDirectoryIfNeeded(at: savesDirectory)
        try fileManager.createDirectoryIfNeeded(at: cacheDirectory)
    }

    var payload: NSDictionary {
        [
            NativeEngineLaunchContextKey.gameId.rawValue: game.id.uuidString,
            NativeEngineLaunchContextKey.gameName.rawValue: game.name,
            NativeEngineLaunchContextKey.gameType.rawValue: game.gameType.rawValue,
            NativeEngineLaunchContextKey.gamePath.rawValue: game.sandboxFriendlyPath.path,
            NativeEngineLaunchContextKey.engineIdentifier.rawValue: engineIdentifier,
            NativeEngineLaunchContextKey.runtimePath.rawValue: runtimeDirectory.path,
            NativeEngineLaunchContextKey.savesPath.rawValue: savesDirectory.path,
            NativeEngineLaunchContextKey.cachePath.rawValue: cacheDirectory.path
        ] as NSDictionary
    }

    private static func sanitizedPathComponent(_ raw: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        let parts = raw.components(separatedBy: allowed.inverted).filter { !$0.isEmpty }
        return parts.isEmpty ? "Game" : parts.joined(separator: "-")
    }
}
