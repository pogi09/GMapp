// UI
import SwiftUI

// MARK: - Этапы дня перенес в  DayStage
 
// MARK: - Настроение дняперенес в DayMood

// MARK: - Атмосферные тексты

// MARK: - Лог перенес в Models/LogEntry.swift

// MARK: - ViewModel перенес в GameViewModel.swift
    // MARK: - Определение настроения дня
    // MARK: - Случайный выбор текста
    // MARK: - Старт игры
    // MARK: - Переход к следующему этапу
    // MARK: - Переход к следующему дню
    // MARK: - Завершение игры
    // MARK: - Добавление лога


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

