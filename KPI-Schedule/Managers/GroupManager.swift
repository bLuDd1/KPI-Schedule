import Foundation

protocol GroupManagerDelegate {
    func didFailWithGroup()
}

struct GroupManager {
    var delegate: GroupManagerDelegate?
    
    func performRequest(group: String, completion: @escaping(GroupModel) -> ()) {
        if let groupURL = URL(string: "https://schedule.kpi.ua/api/schedule/groups") {
            
            URLSession.shared.dataTask(with: groupURL) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithGroup()
                    return
                }
                if let safeData = data {
                    if let group = self.parseJSON(data: safeData, group: group) {
                        completion(group)
                    } else {
                        delegate?.didFailWithGroup()
                    }
                }
            }
            .resume()
        }
    }
    
    func parseJSON(data: Data, group: String) -> GroupModel? {
        do {
            let decodedData = try JSONDecoder().decode(GroupData.self, from: data)
            for groupa in decodedData.data {
                if groupa.name == group {
                    return GroupModel(name: groupa.name, faculty: groupa.faculty, id: groupa.id)
                }
            }
        } catch {
            DispatchQueue.main.async {
                delegate?.didFailWithGroup()
            }
        }
        return nil
    }
}
