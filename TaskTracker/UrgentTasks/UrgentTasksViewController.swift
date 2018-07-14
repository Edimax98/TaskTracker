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
		df.dateFormat = DateFormat.day.description
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
	
	private func fetchUrgentTasks() {
		
		let appDelegate = AppDelegate.getAppDelegate()
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
		let filter = dateFormatter.string(from: Date())
		let predicate = NSPredicate(format: "date == %@", filter)
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
