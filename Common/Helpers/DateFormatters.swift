import Foundation

// MARK: - DateFormatters

enum DateFormatters {
    
    // MARK: - Formatters
    
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
    
    static let displayDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.dateStyle = .short
        return formatter
    }()
    
    // MARK: - Helpers
    
    static func formatISODate(_ isoString: String) -> String? {
        guard let date = iso8601.date(from: isoString) else {
            print("❌ [DateFormatters] Failed to parse date: \(isoString)")
            return nil
        }
        return displayDate.string(from: date)
    }
}
