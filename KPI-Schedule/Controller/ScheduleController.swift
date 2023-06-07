import UIKit

class ScheduleController: UITableViewController {
    
    var scheduleManager = ScheduleManager()
    var firstWeekSchedule = [Day]()
    var secondWeekSchedule = [Day]()
    var scheduleWeek = [Day]()
    var defaults = UserDefaults()
    var daysWithPairs = [Day]()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func changeWeek(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            scheduleWeek = firstWeekSchedule
        case 1:
            scheduleWeek = secondWeekSchedule
        default:
            scheduleWeek = firstWeekSchedule
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}

