import Foundation

struct MoonData {
    static var moonRecords: [String: Double] = [:]

    static func loadCSV() {
        guard let path = Bundle.main.path(forResource: "FINALMOONPHASE", ofType: "csv") else {
            print("❌ CSV not found")
            return
        }

        do {
            let data = try String(contentsOfFile: path)
            let rows = data.components(separatedBy: "\n")
            for row in rows.dropFirst() {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 4 {
                    let key = "\(columns[0])-\(columns[1])-\(columns[2])"
                    if let area = Double(columns[3]) {
                        moonRecords[key] = area
                    }
                }
            }
        } catch {
            print("❌ Failed to load CSV: \(error)")
        }
    }

    static func area(for date: Date) -> Double? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-M-d"
        let key = formatter.string(from: date)
        return moonRecords[key]
    }
}
