import UIKit

class ScheduleController: UITableViewController {
    
    var scheduleManager = ScheduleManager()
    var firstWeekSchedule = [Day]()
    var secondWeekSchedule = [Day]()
    var scheduleWeek = [Day]()
    var defaults = UserDefaults()
    var daysWithPairs = [Day]()
    let defaultId = "4700e2be-e8a9-4b9e-859e-b44ece843445"

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleManager.delegate = self
        navigationItem.title = defaults.string(forKey: "selectedGroupName") ?? "ІМ-13"
        scheduleManager.getSchedule(id: defaults.string(forKey: "selectedGroupId") ?? defaultId)

    }
    
    @IBAction func changeWeek(_ sender: UISegmentedControl) {
        let selectedSchedule = sender.selectedSegmentIndex == 1 ? secondWeekSchedule : firstWeekSchedule
        scheduleWeek = selectedSchedule
    
        DispatchQueue.main.async {
        self.tableView.reloadData()
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
