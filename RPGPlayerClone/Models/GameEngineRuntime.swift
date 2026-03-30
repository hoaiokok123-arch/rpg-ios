import Foundation

enum GameEngineRuntime: String, Codable, CaseIterable, Hashable, Identifiable, Sendable {
    case easyRPG = "easyrpg"
    case mkxpz = "mkxpz"
    case web = "web"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .easyRPG:
            return "EasyRPG Player"
        case .mkxpz:
            return "mkxp-z"
        case .web:
            return "WKWebView"
        }
    }

    func supports(_ gameType: GameType) -> Bool {
        gameType.compatibleEngines.contains(self) || gameType == .unknown
    }
}
