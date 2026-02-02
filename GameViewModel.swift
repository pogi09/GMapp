// ВСЯ логика игры

import SwiftUI

final class GameViewModel: ObservableObject {

    @Published var day = 1
    @Published var stage: DayStage = .sunrise
    @Published var logs: [LogEntry] = []
    @Published var started = false
    @Published var finished = false
    
    // MARK: - Определение настроения дня
    private func moodForDay(_ day: Int) -> DayMood {
        DayMood(rawValue: day) ?? .acceptance
    }
    
    // MARK: - Случайный выбор текста
    private func random(_ texts: [String]) -> String {
        texts.randomElement() ?? ""
    }
    
    // MARK: - Старт игры
    func startGame() {
        started = true
        finished = false
        day = 1
        stage = .sunrise
        logs = []

        let mood = moodForDay(day)
        let texts = AtmosphereTexts.texts[mood]?[stage] ?? []
        addLog(random(texts))
    }
    
    // MARK: - Переход к следующему этапу
    func nextStep() {
        if let next = DayStage(rawValue: stage.rawValue + 1) {
            stage = next

            let mood = moodForDay(day)
            let texts = AtmosphereTexts.texts[mood]?[stage] ?? []
            addLog(random(texts))
        } else {
            nextDay()
        }
    }
    
    // MARK: - Переход к следующему дню
    private func nextDay() {
        if day >= 7 {
            finished = true
            addLog()
        } else {
            day += 1
            stage = .sunrise
            let mood = moodForDay(day)
            let texts = AtmosphereTexts.texts[mood]?[stage] ?? []
            addLog(random(texts))
        }
    }

    // MARK: - Завершение игры
    private func finishGame() {
        finished = true
        let mood = moodForDay(7)
        let texts = AtmosphereTexts.texts[mood]?[.sunset] ?? []
        addLog(random(texts))
    }
    
    // MARK: - Добавление лога
    private func addLog() {
        let text = AtmosphereTexts.log(day: day, stage: stage)
        logs.append(LogEntry(text: text))
    }
}
