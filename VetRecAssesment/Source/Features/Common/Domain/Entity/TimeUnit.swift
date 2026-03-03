import Foundation

enum TimeUnit: String, CaseIterable, Codable, Identifiable {
    case hours
    case days

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
