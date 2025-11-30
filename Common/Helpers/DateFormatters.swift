import Foundation

// MARK: - DateFormatters

enum DateFormatters {
    
    // MARK: - Formatters
    
    /// ISO 8601 parser for incoming API dates (format: "yyyy-MM-dd'T'HH:mm:ss")
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    /// Display formatter for UI
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        return formatter
    }()
    
    // MARK: - Helpers
    
    /// Converts ISO 8601 string to display-friendly format
    static func formatISODate(_ isoString: String) -> String? {
        guard let date = iso8601.date(from: isoString) else {
            print("❌ [DateFormatters] Failed to parse date: \(isoString)")
            return nil
        }
        return displayDate.string(from: date)
    }
}
