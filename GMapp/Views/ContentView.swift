//
//  ContentView.swift
//  GMapp
//
//  Created by Oleg polishchuk on 02.02.2026.
//
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

import SwiftUI

struct ContentView: View {

    @StateObject private var vm = GameViewModel()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            StarField()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                header
                consoleCard
                Spacer()
                actionButton
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
    }

    var header: some View {
        VStack(spacing: 6) {
            Text("DAY \(vm.day) / 7")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.green)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.green.opacity(0.4), lineWidth: 1)
                        )
                )

            Text(vm.stage.title.uppercased())
                .font(.title.bold())
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.9), radius: 4)
        }
        .opacity(0.85)   // ← ВОТ СЮДА мы  вставили редактирование для счетчика дней
        .shadow(color: .black.opacity(0.6), radius: 6)
    }

    var consoleCard: some View {
        ZStack {
            Image("cyberConsole")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 350)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.8), radius: 12)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.green.opacity(0.4), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.8), radius: 8)
                        .padding(.horizontal, 15)
                        .frame(height: 140)
                        .overlay(
                            ScrollView {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(vm.logs) { log in
                                        Text("> \(log.text)")
                                            .font(.system(.footnote, design: .monospaced))
                                            .foregroundColor(.green)
                                            .shadow(color: .green.opacity(0.6), radius: 2)
                                    }
                                }
                                .padding(16)
                            }
                        )
                        .offset(y: -10) // плашку можно подрегулировать отдельно
                )
        }
        .frame(height: 260)
        .offset(y: 100) // двигаем всю консоль вниз
    }

    var actionButton: some View {
        Button {
            vm.nextStep()
        } label: {
            Text("Continue")
                .font(.headline)
                .foregroundColor(.black)
                .frame(width: UIScreen.main.bounds.width / 3, height: 50)
                .background(
                    LinearGradient(
                        colors: [.orange, .red],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(16)
                .shadow(radius: 8)
        }
    }
}

// MARK: - Звёздный фон с полётом
struct StarField: View {
    @State private var stars: [Star] = []
    @State private var timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let center = CGPoint(x: size.width/2, y: size.height/2)

            Canvas { context, _ in
                for star in stars {
                    context.fill(
                        Path(ellipseIn: CGRect(x: star.position.x, y: star.position.y, width: star.size, height: star.size)),
                        with: .color(.white.opacity(star.opacity))
                    )
                }
            }
            .onAppear {
                // Инициализация звёзд
                if stars.isEmpty {
                    stars = (0..<200).map { _ in Star.random(in: size) }
                }
            }
            .onReceive(timer) { _ in
                for i in stars.indices {
                    var star = stars[i]

                    let dx = star.position.x - center.x
                    let dy = star.position.y - center.y
                    let dist = sqrt(dx*dx + dy*dy)
                    let factor: CGFloat = 1 + dist * 0.05
                    star.position.x += star.direction.dx * star.velocity * factor
                    star.position.y += star.direction.dy * star.velocity * factor

                    // Если звезда вышла за границы — возвращаем в центр с рандомизацией
                    if star.position.x < 0 || star.position.x > size.width ||
                        star.position.y < 0 || star.position.y > size.height {
                        star.position = CGPoint(
                            x: center.x + CGFloat.random(in: -20...20),
                            y: center.y + CGFloat.random(in: -20...20)
                        )
                        star.velocity = CGFloat.random(in: 1.5...4)
                        let angle = Double.random(in: 0..<360) * .pi / 180
                        star.direction = CGVector(dx: cos(angle), dy: sin(angle))
                    }

                    stars[i] = star
                }
            }
        }
    }
}

struct Star {
    var position: CGPoint
    var velocity: CGFloat
    var size: CGFloat
    var opacity: Double
    var direction: CGVector

    static func random(in size: CGSize) -> Star {
        let angle = Double.random(in: 0..<360) * .pi / 180
        let center = CGPoint(x: size.width/2, y: size.height/2)
        return Star(
            position: CGPoint(
                x: center.x + CGFloat.random(in: -20...20),
                y: center.y + CGFloat.random(in: -20...20)
            ),
            velocity: CGFloat.random(in: 1.5...4),
            size: CGFloat.random(in: 1.5...3),
            opacity: Double.random(in: 0.7...1),
            direction: CGVector(dx: cos(angle), dy: sin(angle))
        )
    }
}
