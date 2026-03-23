# 🌅 THE PATH — GMapp

> A 7-day atmospheric journey through moods, thoughts, and acceptance.

---

## 📱 Preview

<!-- Замени ссылку ниже на свой GIF после того как запишешь его -->
![Gameplay](https://YOUR_GIF_LINK_HERE)

---

## 🖼 Screenshots

<!-- Вставь свои скриншоты — загрузи их на imgur.com и вставь ссылки -->
<p float="left">
  <img src="https://YOUR_SCREENSHOT_1" width="200"/>
  <img src="https://YOUR_SCREENSHOT_2" width="200"/>
  <img src="https://YOUR_SCREENSHOT_3" width="200"/>
</p>

---

## 🎮 About

**THE PATH** is a minimalist iOS game where you walk through 7 days, each with its own mood and atmosphere. No enemies. No scores. Just the path.

- 🌄 7 days × 4 stages each
- 🎭 Unique mood per day: hope → curiosity → doubt → effort → fatigue → reflection → acceptance
- 📖 Atmospheric log entries that evolve with each stage
- 🌍 Localized interface

---

## 🏗 Architecture

```
GMapp/
├── Models/
│   ├── DayMood.swift
│   ├── DayStage.swift
│   └── LogEntry.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Views/
│   └── ContentView.swift
├── Services/
│   └── AtmosphereTexts.swift
└── Resources/
    └── Localizable.strings
```

---

## 🛠 Built With

![Swift](https://img.shields.io/badge/Swift-5.9-orange?logo=swift)
![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?logo=apple)
![iOS](https://img.shields.io/badge/iOS-16%2B-lightgrey?logo=apple)
![MVVM](https://img.shields.io/badge/Architecture-MVVM-green)

---

## 🚀 Getting Started

```bash
git clone https://github.com/pogi09/GMapp.git
cd GMapp
open GMapp.xcodeproj
```

> Build and run on iPhone simulator or real device (iOS 16+)

---

## 📄 License

© 2026 Oleg Polishchuk. All rights reserved.  
Assets and visual content are not included in this repository.
