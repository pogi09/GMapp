struct AtmosphereTexts {

    static func log(day: Int, stage: DayStage) -> String {
        let key = "log_day\(day)_\(stage.title)"
        return NSLocalizedString(key, comment: "")
    }
}
