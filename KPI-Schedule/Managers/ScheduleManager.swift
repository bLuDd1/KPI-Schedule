import Foundation

protocol ScheduleManagerDelegate {
    func didUpdate(_ scheduleManager: ScheduleManager, schedule: Schedule)
    func didFail()
}

struct ScheduleManager {
    var delegate: ScheduleManagerDelegate?

    
    func getSchedule(id: String) {
        let scheduleURL = "https://schedule.kpi.ua/api/schedule/lessons?groupId=\(id)"
        if let safeUrlString = scheduleURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            performRequest(with: safeUrlString)
        }
    }
    
    func performRequest(with scheduleURL: String) {

        
        if let url = URL(string: scheduleURL) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error getting schedule - \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        delegate?.didFail()
                    }
                    return
                }
                if let safeData = data {
                    if let schedule = self.parseJSON(safeData) {
                        DispatchQueue.main.async {
                            delegate?.didUpdate(self, schedule: schedule)
                        }
                    }
                }
            }
            .resume()
        }
    }
    
    func parseJSON(_ scheduleData: Data) -> Schedule? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(Schedule.self, from: scheduleData)
            return decodedData
        } catch {
            delegate?.didFail()
            return nil
        }
    }
}
