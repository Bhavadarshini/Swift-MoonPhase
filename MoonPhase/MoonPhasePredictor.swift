
import Foundation
import CoreML

struct MoonPhasePrediction {
    let phase: String
    let confidence: Double
}

class MoonPhasePredictor {
    private let model: MoonPhase

    init?() {
        guard let model = try? MoonPhase(configuration: .init()) else {
            print("❌ Failed to load model")
            return nil
        }
        self.model = model
    }

    func predictPhase(from date: Date, area: Double) -> MoonPhasePrediction? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        guard let year = components.year,
              let month = components.month,
              let day = components.day else {
            return nil
        }

        do {
            let input = MoonPhaseInput(
                Year: Int64(year),
                Month: Int64(month),
                Day: Int64(day),
                Area: area
            )

            let output = try model.prediction(input: input)
            let phaseLabel = moonPhaseLabel(for: Int(output.Category))
            let confidence = output.CategoryProbability[output.Category] ?? 0.0

            return MoonPhasePrediction(phase: phaseLabel, confidence: confidence)

        } catch {
            print("❌ Prediction error: \(error)")
            return nil
        }
    }

    func moonPhaseLabel(for index: Int) -> String {
        switch index {
        case 0: return "🌑 New Moon"
        case 1: return "🌒 Waxing Crescent"
        case 2: return "🌓 First Quarter"
        case 3: return "🌔 Waxing Gibbous"
        case 4: return "🌕 Full Moon"
        case 5: return "🌖 Waning Gibbous"
        case 6: return "🌗 Last Quarter"
        case 7: return "🌘 Waning Crescent"
        default: return "Unknown Phase"
        }
    }
}
