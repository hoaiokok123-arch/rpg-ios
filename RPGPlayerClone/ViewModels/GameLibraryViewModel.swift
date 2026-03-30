import Combine
import Foundation

@MainActor
final class GameLibraryViewModel: ObservableObject {
    @Published var games: [Game] = []
    @Published var statusMessage: String?
    @Published var activityMessage: String?
    @Published var isBusy = false

    private let store: GameLibraryStore
    private let importer: FileImporter
    private let fileManager = FileManager.default

    private struct ImportOutcome: Sendable {
        let importedGames: [Game]
        let failures: [String]
    }

    init(store: GameLibraryStore = .shared, importer: FileImporter = .shared) {
        self.store = store
        self.importer = importer
        loadGames()
    }

    func loadGames() {
        let loadedGames = store.loadGames().filter { fileManager.itemExists(at: $0.path) }
        games = sorted(loadedGames)
        persistGames()
        rescanLibrary(showStatus: false)
    }

    func deleteGame() {
        statusMessage = "Hay goi deleteGame(_:) hoac deleteGame(at:)."
    }

    func deleteGame(_ game: Game) {
        if fileManager.itemExists(at: game.path) {
            try? fileManager.removeItem(at: game.path)
        }

        games.removeAll { $0.id == game.id }
        persistGames()
    }

    func deleteGame(at offsets: IndexSet) {
        for offset in offsets.sorted(by: >) {
            deleteGame(games[offset])
        }
    }

    func importGameFromFiles() {
        statusMessage = "Hay truyen URL vao importGameFromFiles(urls:)."
    }

    func importGameFromFiles(urls: [URL]) {
        guard !urls.isEmpty else {
            return
        }

        isBusy = true
        activityMessage = "Dang import \(urls.count) muc..."

        let importer = self.importer
        let store = self.store

        Task {
            let outcome = await Task.detached(priority: .userInitiated) { () -> ImportOutcome in
                var importedGames: [Game] = []
                var failures: [String] = []

                for url in urls {
                    switch importer.importGame(from: url) {
                    case .success(let importedURL):
                        importedGames.append(store.makeGame(from: importedURL))
                    case .failure(let error):
                        failures.append("\(url.lastPathComponent): \(error.localizedDescription)")
                    }
                }

                return ImportOutcome(importedGames: importedGames, failures: failures)
            }.value

            var merged = games
            for game in outcome.importedGames {
                merged.removeAll { $0.path.standardizedFileURL == game.path.standardizedFileURL }
                merged.append(game)
            }

            games = sorted(merged)
            persistGames()
            isBusy = false
            activityMessage = nil

            if !outcome.importedGames.isEmpty && outcome.failures.isEmpty {
                statusMessage = "Da import \(outcome.importedGames.count) muc."
            } else if outcome.failures.isEmpty {
                statusMessage = nil
            } else {
                statusMessage = outcome.failures.joined(separator: "\n")
            }
        }
    }

    func markPlayed(_ game: Game) {
        guard let index = games.firstIndex(where: { $0.id == game.id }) else {
            return
        }

        games[index].lastPlayed = Date()
        games = sorted(games)
        persistGames()
    }

    func rescanLibrary(showStatus: Bool = true) {
        guard !isBusy else {
            return
        }

        let existingGames = games
        let store = self.store

        isBusy = true
        activityMessage = showStatus ? "Dang quet lai thu vien..." : nil

        Task {
            let rescannedGames = await Task.detached(priority: .userInitiated) {
                store.rescanGames(preserving: existingGames)
            }.value

            games = sorted(rescannedGames)
            persistGames()
            isBusy = false
            activityMessage = nil

            guard showStatus else {
                return
            }

            if rescannedGames.isEmpty {
                statusMessage = "Chua tim thay game nao trong Documents/Games."
            } else {
                let playableCount = rescannedGames.filter { $0.isPlayable }.count
                statusMessage = "Da quet \(rescannedGames.count) muc. Co \(playableCount) game co the khoi chay."
            }
        }
    }

    func updateEngineOverride(for game: Game, engineOverride: GameEngineRuntime?) {
        guard let index = games.firstIndex(where: { $0.id == game.id }) else {
            return
        }

        if let engineOverride, !engineOverride.supports(games[index].gameType) {
            statusMessage = "Engine \(engineOverride.displayName) khong phu hop voi \(games[index].gameType.displayName)."
            return
        }

        games[index].engineOverride = engineOverride
        games = sorted(games)
        persistGames()
    }

    func refreshGameMetadata(_ game: Game) {
        guard let index = games.firstIndex(where: { $0.id == game.id }) else {
            return
        }

        let refreshed = store.makeGame(from: games[index].path, preserving: games[index])
        games[index] = refreshed
        games = sorted(games)
        persistGames()
        statusMessage = "Da cap nhat metadata cho \(refreshed.name)."
    }

    private func persistGames() {
        do {
            try store.saveGames(games)
        } catch {
            statusMessage = error.localizedDescription
        }
    }

    private func sorted(_ input: [Game]) -> [Game] {
        input.sorted { lhs, rhs in
            switch (lhs.lastPlayed, rhs.lastPlayed) {
            case let (left?, right?):
                if left != right {
                    return left > right
                }
            case (.some, .none):
                return true
            case (.none, .some):
                return false
            case (.none, .none):
                break
            }

            return lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
        }
    }
}
