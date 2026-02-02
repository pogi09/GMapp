import SwiftUI

// MARK: - Этапы дня
enum DayStage: Int, CaseIterable {
    case sunrise, noon, evening, sunset

    struct Atmosphere {

    static let start = [
        "Ты делаешь первый шаг.",
        "Путь начинается в тишине.",
        "Ничто не требует спешки."
    ]

    static let sunrise = [
        "Свет медленно пробивается сквозь темноту.",
        "Утро не задаёт вопросов.",
        "Ты чувствуешь начало."
    ]

    static let noon = [
        "День идёт своим чередом.",
        "Мысли становятся яснее.",
        "Ты продолжаешь путь."
    ]

    static let evening = [
        "Скоро станет тише.",
        "День начинает отпускать.",
        "Ты оглядываешься назад."
    ]

    static let sunset = [
        "Свет уходит, но не навсегда.",
        "Закат не означает конец.",
        "Ты позволяешь дню завершиться."
    ]

    static let newDay = [
        "Новый день — новый шаг.",
        "Ты просыпаешься другим.",
        "Путь продолжается."
    ]

    static let finish = [
        "Путь завершён.",
        "Ты дошёл до конца.",
        "Теперь можно остановиться."
    ]
}

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
    
    private func random(_ texts: [String]) -> String {
        texts.randomElement() ?? ""
    }

    func startGame() {
        started = true
        finished = false
        day = 1
        stage = .sunrise
        logs = []
        addLog(random(Atmosphere.start))
    }


    func nextStep() {
    if let nextStage = DayStage(rawValue: stage.rawValue + 1) {
        stage = nextStage

        switch stage {
        case .sunrise:
            addLog(random(Atmosphere.sunrise))
        case .noon:
            addLog(random(Atmosphere.noon))
        case .evening:
            addLog(random(Atmosphere.evening))
        case .sunset:
            addLog(random(Atmosphere.sunset))
        }

    } else {
        nextDay()
    }
}


    private func nextDay() {
    if day >= 7 {
        finishGame()
    } else {
        day += 1
        stage = .sunrise
        addLog(random(Atmosphere.newDay))
    }
}


    private func finishGame() {
    finished = true
    addLog(random(Atmosphere.finish))
}
    

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

    // MARK: Start
    private var startScreen: some View {
        VStack(spacing: 24) {
            Text("ПУТЬ")
                .font(.largeTitle)
                .fontWeight(.bold)

            Button("Начать путь") {
                vm.startGame()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    // MARK: Game
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

                Button("Продолжить путь") {
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

    // MARK: Finish
    private var finishScreen: some View {
        VStack(spacing: 24) {
            Text("Путь завершён")
                .font(.largeTitle)

            Button("Начать заново") {
                vm.startGame()
            }
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
    }

    // MARK: Console
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
