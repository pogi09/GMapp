// UI
import SwiftUI

// MARK: - Этапы дня
enum DayStage: Int, CaseIterable {
    case sunrise, noon, evening, sunset

    var title: String {
        switch self {
        case .sunrise: return "Восход"
        case .noon: return "Полдень"
        case .evening: return "Вечер"
        case .sunset: return "Закат"
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

// MARK: - Настроение дня
enum DayMood: Int {
    case hope = 1, curiosity, doubt, effort, fatigue, reflection, acceptance
}

// MARK: - Атмосферные тексты
struct AtmosphereTexts {
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
}

// MARK: - Лог
struct LogEntry: Identifiable {
    let id = UUID()
    let text: String
}

// MARK: - ViewModel
final class GameViewModel: ObservableObject {

    @Published var day: Int = 1
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
        if let nextStage = DayStage(rawValue: stage.rawValue + 1) {
            stage = nextStage

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
            finishGame()
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
    private func addLog(_ text: String) {
        logs.append(LogEntry(text: text))
    }
}

// MARK: - UI
struct ContentView: View {

    @StateObject private var vm = GameViewModel()

    var body: some View {
        ZStack {
            if !vm.started {
                startScreen
            } else if vm.finished {
                finishScreen
            } else {
                gameScreen
            }
        }
        .animation(.easeInOut, value: vm.started)
    }

    // MARK: Start screen
    private var startScreen: some View {
        VStack(spacing: 24) {
            Text("ПУТЬ")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button(LocalizedStringKey("start_path")) {
                vm.startGame()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    // MARK: Game screen
    private var gameScreen: some View {
        ZStack {
            vm.stage.backgroundColor
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("День \(vm.day) / 7")
                    .font(.headline)

                Text(vm.stage.title)
                    .font(.title2)

                console

                Button(LocalizedStringKey("continue_path")) {
                    vm.nextStep()
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding()
        }
    }

    // MARK: Finish screen
    private var finishScreen: some View {
        VStack(spacing: 24) {
            Text(LocalizedStringKey("path_finished"))
                .font(.largeTitle)

            Button(LocalizedStringKey("restart")) {
                vm.startGame()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    // MARK: Console logs
    private var console: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(vm.logs) { log in
                    Text("> \(log.text)")
                        .font(.system(.caption, design: .monospaced))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .foregroundColor(.green)
        .cornerRadius(12)
        .frame(height: 200)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

