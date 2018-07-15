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
				dataDisplayManager.setTasks(tasks)
			} else {
				print("Could not cast NSManagedObject to Task")
				return
			}
		} catch let error {
			print("Could not fetch. \(error)")
		}
	}
}

// MARK: - UITableViewDelegate
extension UrgentTasksViewController: UITableViewDelegate {
	
}
