import UIKit

class ScheduleController: UITableViewController {
    
    var scheduleManager = ScheduleManager()
    var firstWeekSchedule = [Day]()
    var secondWeekSchedule = [Day]()
    var scheduleWeek = [Day]()
    var defaults = UserDefaults()
    var daysWithPairs = [Day]()
    
    var defaultId: String = "4700e2be-e8a9-4b9e-859e-b44ece843445"
    var defaultGroup: String = "ІМ-13"

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleManager.delegate = self
        navigationItem.title = defaults.string(forKey: "selectedGroupName") ?? defaultGroup
        scheduleManager.getSchedule(id: defaults.string(forKey: "selectedGroupId") ?? defaultId)

    }
    
    @IBAction func changeWeek(_ sender: UISegmentedControl) {
        var isSecondWeekSelected: Bool = false
        isSecondWeekSelected.toggle()
        scheduleWeek = isSecondWeekSelected ? secondWeekSchedule : firstWeekSchedule
    
        DispatchQueue.main.async {
        self.tableView.reloadData()
        }
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        navigationItem.title = defaults.string(forKey: "selectedGroupName") ?? defaultGroup
        scheduleManager.getSchedule(id: defaults.string(forKey: "selectedGroupId") ?? defaultId)
    }
}

    

extension ScheduleController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        daysWithPairs = []
        for day in scheduleWeek {
            if !day.pair.isEmpty {
                daysWithPairs.append(day)
            }
        }

        return daysWithPairs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWithPairs[section].pair.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairCell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        let pair = daysWithPairs[indexPath.section].pair[indexPath.row]
        let pairName = pair.type != "" ? "\(pair.name) (\(pair.type))" : pair.name
        configuration.text = pairName
        configuration.secondaryText = pair.time
        configuration.secondaryTextProperties.color = .systemBlue
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pairs = daysWithPairs[indexPath.section].pair[indexPath.row]
        
        let alertTitle = pairs.type != "" ? "\(pairs.name) (\(pairs.type))" : pairs.name
        lazy var alertMessage: String = {
            if !pairs.teacherName.isEmpty && !pairs.place.isEmpty {
                return "\(pairs.teacherName)\n\(pairs.place)"
            } else if !pairs.teacherName.isEmpty {
                return pairs.teacherName
            } else if !pairs.place.isEmpty {
                return pairs.place
            }
            return ""
        }()
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel))
        present(alert, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if daysWithPairs[section].pair.isEmpty {
            return nil
        }
        
        switch daysWithPairs[section].day {
        case .monday:
            return NSLocalizedString("Monday", comment: "")
        case .tuesday:
            return NSLocalizedString("Tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("Wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("Thursday", comment: "")
        case .friday:
            return NSLocalizedString("Friday", comment: "")
        case .saturday:
            return NSLocalizedString("Saturday", comment: "")
        }
    }
}

extension ScheduleController: ScheduleManagerDelegate {
    func didUpdate(_ scheduleManager: ScheduleManager, schedule: ScheduleData) {
        firstWeekSchedule = sortPairs(in: schedule.data.scheduleFirstWeek)
        secondWeekSchedule = sortPairs(in: schedule.data.scheduleSecondWeek)
        scheduleWeek = firstWeekSchedule

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFail(error: Error) {
        print(error)
    }
    
    func sortPairs(in week: [Day]) -> [Day] {
        var newWeek = week
        for i in 0...5 {
            //TODO: don't use !
            newWeek[i].pair.sort { Double($0.time)! < Double($1.time)! }
        }
        return newWeek
    }
}
