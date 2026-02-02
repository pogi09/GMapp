// все тексты и локализация --- AtmosphereTexts — не файл «про UI» и не «про игру», это словарь атмосферы.
import Foundation
import SwiftUI

/// Атмосферные тексты для каждого дня и этапа
/// Используется в GameViewModel для логов
struct AtmosphereTexts {

    /// Основной словарь для MVP
    static let texts: [DayMood: [DayStage: [String]]] = [
        .hope: [
            .sunrise: ["Всё кажется возможным.", "Ты веришь, что путь приведёт к свету."],
            .noon: ["Надежда придаёт сил.", "Ты идёшь легко."],
            .evening: ["День был добр."],
            .sunset: ["Ты не сомневаешься."]
        ],
        .curiosity: [
            .sunrise: ["Утро открывает новые вопросы."],
            .noon: ["Ты ищешь ответы на пути."],
            .evening: ["Всё кажется интересным."],
            .sunset: ["Новый опыт накоплен."]
        ],
        .doubt: [
            .sunrise: ["Мысли приходят раньше света."],
            .noon: ["Ты начинаешь задавать вопросы."],
            .evening: ["Не все ответы найдены."],
            .sunset: ["Сомнение остаётся."]
        ],
        .effort: [
            .sunrise: ["Ты собираешь силы для пути."],
            .noon: ["Трудности не пугают."],
            .evening: ["Ты продолжаешь идти."],
            .sunset: ["День завершён, но путь продолжается."]
        ],
        .fatigue: [
            .sunrise: ["Утро тяжёлое, но ты идёшь."],
            .noon: ["Ноги устали, мысли яснее."],
            .evening: ["Ты учишься принимать усталость."],
            .sunset: ["Скоро отдых, скоро путь продолжится."]
        ],
        .reflection: [
            .sunrise: ["Ты оглядываешься на пройденное."],
            .noon: ["Мысли глубоки, сердце спокойно."],
            .evening: ["Ты находишь смысл в каждом шаге."],
            .sunset: ["Скоро финал, время оценить путь."]
        ],
        .acceptance: [
            .sunrise: ["Ты принимаешь утро таким, какое оно есть."],
            .noon: ["Ничего не нужно менять."],
            .evening: ["Ты не борешься с усталостью."],
            .sunset: ["Путь был именно таким."]
        ]
    ]

    /// Возвращает случайный текст для данного настроения и этапа дня
    /// - Parameters:
    ///   - mood: настроение дня
    ///   - stage: этап дня
    /// - Returns: случайный текст или пустую строку
    static func random(mood: DayMood, stage: DayStage) -> String {
        let textsForStage = texts[mood]?[stage] ?? []
        return textsForStage.randomElement() ?? ""
    }

    /// Метод для будущей локализации EN/RU
    /// Можно использовать вместо `texts` для подключения Localizable.strings
    /// - Parameters:
    ///   - day: номер дня (1–7)
    ///   - stage: этап дня
    /// - Returns: локализованный текст
    static func log(day: Int, stage: DayStage) -> String {
        let key = "log_day\(day)_\(stage.title)"
        return NSLocalizedString(key, comment: "")
    }
}


