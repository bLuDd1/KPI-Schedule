import Foundation

struct GroupModel: Codable {
    var name: String
    var faculty: String
    var id: String
}

struct GroupData: Codable {
    var data: [GroupModel]
}
