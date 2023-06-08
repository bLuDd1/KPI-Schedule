import Foundation

protocol ScheduleManagerDelegate {
    func didUpdate(_ scheduleManager: ScheduleManager, schedule: ScheduleData)
    func didFail(error: Error)
}

struct ScheduleManager {
    let scheduleURL = "https://schedule.kpi.ua/api/schedule/lessons"
    var delegate: ScheduleManagerDelegate?

    
    func getSchedule(id: String) {
        let urlString = "\(scheduleURL)?groupId=\(id)"
        if let safeUrlString = scheduleURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            performRequest(with: safeUrlString)
        }
    }
    
    func performRequest(with scheduleURL: String) {

        if let url = URL(string: scheduleURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        delegate?.didFail(error: error)
                    }
                    return
                }
                if let safeData = data, let schedule = self.parseJSON(safeData) {
                    self.delegate?.didUpdate(self, schedule: schedule)
                }
            }
            .resume()
        }
    }
    
    func parseJSON(_ scheduleData: Data) -> ScheduleData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ScheduleData.self, from: scheduleData)
            return decodedData
        } catch {
            delegate?.didFail(error: error)
            return nil
        }
    }
}
