import Foundation

protocol GroupManagerDelegate {
    func didFailWithGroup()
}

struct GroupManager {
    var delegate: GroupManagerDelegate?
    
    func performRequest(group: String, completion: @escaping (GroupModel) -> ()) {
        var components = URLComponents(string: "https://schedule.kpi.ua/api/schedule/groups")
        // Set query parameters if needed
        let queryItems = [
            URLQueryItem(name: "param1", value: "value1"),
            URLQueryItem(name: "param2", value: "value2")
        ]
        components?.queryItems = queryItems
        
        if let groupURL = components?.url {
            URLSession.shared.dataTask(with: groupURL) { data, response, error in
                if let error = error {
                    self.delegate?.didFailWithGroup()
                    return
                }
                if let safeData = data {
                    if let group = self.parseJSON(data: safeData, group: group) {
                        completion(group)
                    } else {
                        self.delegate?.didFailWithGroup()
                    }
                }
            }
            .resume()
        }
    }
    
    private func parseJSON(data: Data, group: String) -> GroupModel? {
        do {
            let decodedData = try JSONDecoder().decode(GroupData.self, from: data)
            for groupa in decodedData.data {
                if groupa.name == group {
                    return GroupModel(name: groupa.name, faculty: groupa.faculty, id: groupa.id)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.delegate?.didFailWithGroup()
            }
        }
        return nil
    }
}
