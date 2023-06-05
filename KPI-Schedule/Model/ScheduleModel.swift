import Foundation

struct ScheduleData: Codable {
    var data: Schedule
}

struct Schedule: Codable {
    var scheduleFirstWeek: [Day]
    var scheduleSecondWeek: [Day]
}

struct Day: Codable {
    var day: String
    var pair: [Pair]
}

struct Pair: Codable {
    var teacherName: String
    var lecturerId: String
    var type: String
    var time: String
    var name: String
    var place: String
    var tag: String
}

enum DayName: String, Codable {
    case monday = "Пн"
    case tuesday = "Вв"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
}
