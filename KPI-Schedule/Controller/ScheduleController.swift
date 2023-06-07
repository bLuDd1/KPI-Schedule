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
    let selectedSchedule = sender.selectedSegmentIndex == 1 ? secondWeekSchedule : firstWeekSchedule
    scheduleWeek = selectedSchedule
    
    DispatchQueue.main.async {
        self.tableView.reloadData()
    }
}

    
    

}

