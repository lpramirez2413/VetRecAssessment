import Foundation

enum Species: String, CaseIterable, Codable, Identifiable {
    case dog
    case cat
    case bird

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}
