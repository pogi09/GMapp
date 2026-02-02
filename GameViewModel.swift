// ВСЯ логика игры

import SwiftUI

final class GameViewModel: ObservableObject {

    @Published var day = 1
    @Published var stage: DayStage = .sunrise
    @Published var logs: [LogEntry] = []
    @Published var started = false
    @Published var finished = false

    private func moodForDay(_ day: Int) -> DayMood {
        DayMood(rawValue: day) ?? .acceptance
    }

    func startGame() {
        started = true
        finished = false
        day = 1
        stage = .sunrise
        logs = []
        addLog()
    }

    func nextStep() {
        if let next = DayStage(rawValue: stage.rawValue + 1) {
            stage = next
            addLog()
        } else {
            nextDay()
        }
    }

    private func nextDay() {
        if day >= 7 {
            finished = true
            addLog()
        } else {
            day += 1
            stage = .sunrise
            addLog()
        }
    }

    private func addLog() {
        let text = AtmosphereTexts.log(day: day, stage: stage)
        logs.append(LogEntry(text: text))
    }
}
