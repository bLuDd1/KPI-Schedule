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


}

