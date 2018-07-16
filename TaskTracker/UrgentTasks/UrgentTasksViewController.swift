//
//  UrgentTasksViewController.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 15.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import CoreData

class UrgentTasksViewController: UIViewController {

	@IBOutlet weak var urgentTasksTableView: UITableView!
	var output: TaskViewOutput?
	
	private var selectedTask: Task?
	private var dataDisplayManager = TasksDataDisplayManager()
	private var dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = DateFormat.dateWithoutTimeZone.description
		return df
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		fetchUrgentTasks()
		setupTableView()
		setupView()
    }
	
	private func setupTableView() {
		
		urgentTasksTableView.delegate = self
		urgentTasksTableView.dataSource = dataDisplayManager
		urgentTasksTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: TaskCell.identifier)
	}
	
	private func setupView() {
		
		self.title = "Urgent tasks".localized
	}
	
	private func getBorderDates() -> (start: NSDate, end: NSDate)? {
		
		let todayStr = dateFormatter.string(from: Date())
		guard let todayDate = dateFormatter.date(from: todayStr) else {
			print("Could not get today date")
			return nil
		}
		
		guard let startDate = Calendar.current.date(byAdding: .day, value: -1, to: todayDate) as NSDate? else {
			print("Could not get start date")
			return nil
		}
		
		guard let endDate = Calendar.current.date(byAdding: .day, value: 1, to: todayDate) as NSDate? else {
			print("Could not get end date")
			return nil
		}
		
		return (startDate, endDate)
	}
	
	private func saveUrgentTaskToUserDefaults(_ task: Task) {
		
		guard let userDefaults = UserDefaults(suiteName: "group.com.taskTracker") else {
			print("Could not save to user defaults")
			return
		}
		
		userDefaults.set(task.title, forKey: "urgentTaskTitle")
		userDefaults.set(task.date, forKey: "urgentTaskDate")
	}
	
	private func getClosestUrgentTask(_ tasks: [Task]) -> Task {
		return tasks.min(by: { (prev, next) -> Bool in
			prev.date < next.date
		})!
	}
	
	private func fetchUrgentTasks() {
		
		let appDelegate = AppDelegate.getAppDelegate()
		let managedContext = appDelegate.persistentContainer.viewContext
		
		guard let borderDate = getBorderDates() else {
			print("Could not get border dates")
			return
		}
		
		let predicate = NSPredicate(format: "date > %@ AND date < %@", borderDate.start, borderDate.end)
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
		fetchRequest.predicate = predicate
		do {
			if let tasks = try managedContext.fetch(fetchRequest) as? [Task] {
				dataDisplayManager.setUrgentTasks(tasks)
				let closestTask = getClosestUrgentTask(tasks)
				saveUrgentTaskToUserDefaults(closestTask)
			} else {
				print("Could not cast NSManagedObject to Task")
				return
			}
		} catch let error {
			print("Could not fetch. \(error)")
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "urgentTaskSelected" {
			
			guard let navigationVc = segue.destination as? UINavigationController else {
				print("Error during segue")
				return
			}
			
			guard let destinationVc =  navigationVc.viewControllers.first as? DetailedTaskViewController else {
				print("Could not cast to DetailedTaskViewController or its nil")
				return
			}
			
			self.output = destinationVc
		}
	}
}

// MARK: - UITableViewDelegate
extension UrgentTasksViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let tasks = dataDisplayManager.getUrgentTasks()
		let selectedTask = tasks[indexPath.row]
		
		performSegue(withIdentifier: "urgentTaskSelected", sender: self)
		output?.sendSelectedTask(selectedTask)
	}
}




