import Foundation

enum DurationUnit: String, CaseIterable, Codable, Identifiable {
    case days
    case weeks
    case months

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
