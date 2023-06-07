import Foundation

struct ScheduleData: Decodable {
    var data: Schedule
}

struct Schedule: Decodable {
    var scheduleFirstWeek: [Day]
    var scheduleSecondWeek: [Day]
}

struct Day: Decodable {
    var day: String
    var pair: [Pair]
}

struct Pair: Decodable {
    var teacherName: String
    var lecturerId: String
    var type: String
    var time: String
    var name: String
    var place: String
    var tag: String
}

enum DayName: String, Decodable {
    case monday = "Пн"
    case tuesday = "Вв"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
}
