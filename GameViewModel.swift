// ВСЯ логика игры
import SwiftUI

/// ViewModel игры "Путь" с локализованными текстами
final class GameViewModel: ObservableObject {

    // MARK: - Состояние игры
    @Published var day = 1
    @Published var stage: DayStage = .sunrise
    @Published var logs: [LogEntry] = []
    @Published var started = false
    @Published var finished = false

    // MARK: - Определение настроения дня
    private func moodForDay(_ day: Int) -> DayMood {
        DayMood(rawValue: day) ?? .acceptance
    }

    // MARK: - Старт игры
    func startGame() {
        started = true
        finished = false
        day = 1
        stage = .sunrise
        logs = []

        addCurrentLog()
    }

    // MARK: - Переход к следующему этапу
    func nextStep() {
        if let next = DayStage(rawValue: stage.rawValue + 1) {
            stage = next
            addCurrentLog()
        } else {
            nextDay()
        }
    }

    // MARK: - Переход к следующему дню
    private func nextDay() {
        if day >= 7 {
            finishGame()
        } else {
            day += 1
            stage = .sunrise
            addCurrentLog()
        }
    }

    // MARK: - Завершение игры
    private func finishGame() {
        finished = true
        day = 7
        stage = .sunset
        addCurrentLog()
    }

    // MARK: - Добавление локализованного лога для текущего дня и этапа
    private func addCurrentLog() {
        let text = AtmosphereTexts.log(day: day, stage: stage)
        logs.append(LogEntry(text: text))
    }
}
