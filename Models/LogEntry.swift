// Что это: модель для консоли

import Foundation //Зачем: ---- SwiftUI требует Identifiable

struct LogEntry: Identifiable {
    let id = UUID()
    let text: String
}
