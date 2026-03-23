//
//  GMappApp.swift
//  GMapp
//
//  Created by Oleg polishchuk on 02.02.2026.
//

import SwiftUI

@main
struct GMappApp: App {

    // ViewModel создаётся один раз на уровне приложения
    // и передаётся вниз через environmentObject
    @StateObject private var viewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
