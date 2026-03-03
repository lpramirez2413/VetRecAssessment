import Foundation

enum Species: String, CaseIterable, Codable, Identifiable {
    case axolotl
    case bird
    case bunny
    case camel
    case capybara
    case cat
    case chicken
    case deer
    case dog
    case donkey
    case duck
    case elephant
    case fish
    case goat
    case gorilla
    case guineapig
    case hamster
    case horse
    case jellyfish
    case lizard
    case monkey
    case ostrich
    case penguin
    case rabbit
    case rat
    case rhinoceros
    case sealion
    case shark
    case sheep
    case squirrel
    case swan
    case tarantula
    case tortoise
    case turtle
    case zebra

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .guineapig: return "Guinea Pig"
        case .sealion:   return "Sea Lion"
        default:         return rawValue.capitalized
        }
    }
}
