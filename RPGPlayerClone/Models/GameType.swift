import Foundation

enum GameType: String, Codable, CaseIterable, Hashable, Sendable {
    case rpg2k
    case rpg2k3
    case rpgXP
    case rpgVX
    case rpgVXAce
    case rpgMV
    case rpgMZ
    case unknown

    var displayName: String {
        switch self {
        case .rpg2k:
            return "RPG Maker 2000"
        case .rpg2k3:
            return "RPG Maker 2003"
        case .rpgXP:
            return "RPG Maker XP"
        case .rpgVX:
            return "RPG Maker VX"
        case .rpgVXAce:
            return "RPG Maker VX Ace"
        case .rpgMV:
            return "RPG Maker MV"
        case .rpgMZ:
            return "RPG Maker MZ"
        case .unknown:
            return "Unknown"
        }
    }

    var preferredEngineName: String {
        defaultEngineRuntime?.displayName ?? "Unknown"
    }

    var defaultEngineRuntime: GameEngineRuntime? {
        switch self {
        case .rpg2k, .rpg2k3:
            return .easyRPG
        case .rpgXP, .rpgVX, .rpgVXAce:
            return .mkxpz
        case .rpgMV, .rpgMZ:
            return .web
        case .unknown:
            return nil
        }
    }

    var compatibleEngines: [GameEngineRuntime] {
        switch self {
        case .rpg2k, .rpg2k3:
            return [.easyRPG]
        case .rpgXP, .rpgVX, .rpgVXAce:
            return [.mkxpz]
        case .rpgMV, .rpgMZ:
            return [.web]
        case .unknown:
            return GameEngineRuntime.allCases
        }
    }

    static func detect(from path: URL) -> GameType {
        GameDetector.detectType(from: path)
    }
}
