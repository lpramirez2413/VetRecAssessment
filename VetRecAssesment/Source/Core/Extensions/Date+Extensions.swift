import Foundation

extension Date {

    /// "Feb 25, 2026"
    var shortFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// Parse "2026-02-25" from JSON.
    static func from(iso8601 string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: string)
    }

    /// Add days, weeks, or months for end date
    func adding(_ value: Int, unit: DurationUnit) -> Date {
        let cal = Calendar.current
        switch unit {
        case .days:   return cal.date(byAdding: .day, value: value, to: self) ?? self
        case .weeks:  return cal.date(byAdding: .weekOfYear, value: value, to: self) ?? self
        case .months: return cal.date(byAdding: .month, value: value, to: self) ?? self
        }
    }
}
