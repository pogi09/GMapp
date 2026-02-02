import SwiftUI

enum DayStage: Int, CaseIterable {
    case sunrise, noon, evening, sunset

    var title: String {
        switch self {
        case .sunrise: return "sunrise"
        case .noon: return "noon"
        case .evening: return "evening"
        case .sunset: return "sunset"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .sunrise: return .orange.opacity(0.6)
        case .noon: return .blue.opacity(0.6)
        case .evening: return .purple.opacity(0.6)
        case .sunset: return .red.opacity(0.6)
        }
    }
}
