//
//  GameViewModel.swift
//  GMapp
//
//  Created by Oleg polishchuk on 02.02.2026.
//
// ВСЯ логика игры
import SwiftUI

/// ViewModel игры "Путь" с локализованными текстами
final class GameViewModel: ObservableObject {

    // MARK: - Константы
    private let totalDays = 7

    // MARK: - Состояние игры
    @Published var day = 1
    @Published var stage: DayStage = .sunrise
    @Published var logs: [LogEntry] = []
    @Published var started = false
    @Published var finished = false

    // MARK: - Определение настроения дня
    // Явный switch вместо rawValue — безопасно при изменении enum
    private func moodForDay(_ day: Int) -> DayMood {
        switch day {
        case 1: return .hope
        case 2: return .curiosity
        case 3: return .doubt
        case 4: return .effort
        case 5: return .fatigue
        case 6: return .reflection
        case 7: return .acceptance
        default: return .acceptance
        }
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
        if day >= totalDays {
            finishGame()
        } else {
            day += 1
            stage = .sunrise
            addCurrentLog()
        }
    }

    // MARK: - Завершение игры
    // Исправлено: убран addCurrentLog() — он уже был вызван в nextStep()
    // перед тем как дойти до finishGame(), чтобы не дублировать запись в логах.
    private func finishGame() {
        finished = true
    }

    // MARK: - Добавление локализованного лога для текущего дня и этапа
    private func addCurrentLog() {
        let mood = moodForDay(day)
        let text = AtmosphereTexts.random(mood: mood, stage: stage)
        logs.append(LogEntry(text: text))
    }

}
