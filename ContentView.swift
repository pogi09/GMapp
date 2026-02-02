import SwiftUI

// MARK: - Этапы дня
enum DayStage: Int, CaseIterable {
    case sunrise, noon, evening, sunset

struct AtmosphereTexts {

    static let texts: [DayMood: [DayStage: [String]]] = [

        .hope: [
            .sunrise: [
                "Всё кажется возможным.",
                "Ты веришь, что путь приведёт к свету."
            ],
            .noon: [
                "Надежда придаёт сил.",
                "Ты идёшь легко."
            ],
            .evening: [
                "День был добр.",
            ],
            .sunset: [
                "Ты не сомневаешься."
            ]
        ],

        .doubt: [
            .sunrise: [
                "Мысли приходят раньше света."
            ],
            .noon: [
                "Ты начинаешь задавать вопросы."
            ],
            .evening: [
                "Не все ответы найдены."
            ],
            .sunset: [
                "Сомнение остаётся."
            ]
        ],

        .acceptance: [
            .sunrise: [
                "Ты принимаешь утро таким, какое оно есть."
            ],
            .noon: [
                "Ничего не нужно менять."
            ],
            .evening: [
                "Ты не борешься с усталостью."
            ],
            .sunset: [
                "Путь был именно таким."
            ]
        ]
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

enum DayMood: Int {
    case hope = 1
    case curiosity
    case doubt
    case effort
    case fatigue
    case reflection
    case acceptance
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

    private func moodForDay(_ day: Int) -> DayMood {
        DayMood(rawValue: day) ?? .acceptance
    }
    
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
