//
//  ViewController.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import CoreData

class TasksViewController: UIViewController {

	@IBOutlet weak var tasksTableView: UITableView!
	var output: TaskViewOutput?
	
	var dataDisplayManager = TasksDataDisplayManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		fetchTasks()
	}
	
	private func setupView() {
		self.title = "Tasks".localized
	}
	
	private func setupTableView() {
		tasksTableView.delegate = self
		tasksTableView.dataSource = dataDisplayManager
		tasksTableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: TaskCell.identifier)
	}
	
	@IBAction func filterButtonPressed(_ sender: Any) {
		
		let filterActionSheet = UIAlertController(title: "Choose status of task you want to filter".localized, message: nil, preferredStyle: .actionSheet)
		
		let filterByNewStatusAction = UIAlertAction(title: "New tasks".localized, style: .default) { (action) in
			self.filterTask(by: .new)
		}
		let filterByInProcessStatusAction = UIAlertAction(title: "Tasks in process".localized, style: .default) { (action) in
			self.filterTask(by: .inProcess)
		}
		let filterByDoneStatusAction = UIAlertAction(title: "Completed tasks".localized, style: .default) { (action) in
			self.filterTask(by: .done)
		}
		let cancelFiltrationAction = UIAlertAction(title: "All tasks".localized, style: .default) { (action) in
			self.fetchTasks()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		
		filterActionSheet.addAction(filterByNewStatusAction)
		filterActionSheet.addAction(filterByInProcessStatusAction)
		filterActionSheet.addAction(filterByDoneStatusAction)
		filterActionSheet.addAction(cancelFiltrationAction)
		filterActionSheet.addAction(cancelAction)
		
		self.present(filterActionSheet, animated: true, completion: nil)
	}
	
	private func filterTask(by status: TaskStatus) {
		
		var filter: Int16 = 0
		let appDelegate = AppDelegate.getAppDelegate()
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
		
		switch status {
		case .new:
			filter = TaskStatus.new.rawValue
		case .inProcess:
			filter = TaskStatus.inProcess.rawValue
		case .done:
			filter = TaskStatus.done.rawValue
		case .undefined:
			break
		}
		
		let predicate = NSPredicate(format: "statusValue == %ld", filter)
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
		tasksTableView.reloadData()
	}
	
	func fetchTasks() {
	
		let appDelegate = AppDelegate.getAppDelegate()
		let managedContext = appDelegate.persistentContainer.viewContext
		
		let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Task")
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
		tasksTableView.reloadData()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "taskSelected" {
			
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

extension TasksViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let tasks = dataDisplayManager.getTasks()
		let selectedTask = tasks[indexPath.row]
		
		performSegue(withIdentifier: "taskSelected", sender: self)
		output?.sendSelectedTask(selectedTask)
	}
}

