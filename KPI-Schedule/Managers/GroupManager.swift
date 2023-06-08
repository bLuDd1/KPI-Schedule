import Foundation

protocol GroupManagerDelegate {
    func didUpdate(_ groupListManager: GroupListManager, groupData: GroupData)
    func didFail(error: Error)
}

struct GroupListManager {
    let scheduleURL = "https://schedule.kpi.ua/api/schedule/groups"
    var delegate: GroupManagerDelegate?
    

    func getGroupList() {
        if let safeUrlString = scheduleURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            performRequest(with: safeUrlString)
        }
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.delegate?.didFail(error: error)
                    return
                }
                
                if let safeData = data, let group = self.parseJSON(safeData) {
                    self.delegate?.didUpdate(self, groupData: group)
                }
            }
            task.resume()
        }
    }
    

    func parseJSON(_ groupData: Data) -> GroupData? {
        let decoder = JSONDecoder()
     
        do {
            let decodedData = try decoder.decode(GroupData.self, from: groupData)
            return decodedData
        } catch {

            delegate?.didFail(error: error)
            return nil

        }
    }
}
