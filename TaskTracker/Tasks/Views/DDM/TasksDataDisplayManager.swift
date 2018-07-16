//
//  TasksDataDisplayManager.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class TasksDataDisplayManager: NSObject {
	
	private var tasks = [Task]()
	private var urgentTasks = [Task]()
	private var isUrgentTask = false
	private let dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = DateFormat.dateWithoutTimeZone.description
		return df
	}()
	
	func setTasks(_ tasks: [Task]) {
		self.tasks = tasks
	}
	
	func getTasks() -> [Task] {
		return tasks
	}
	
	func setUrgentTasks(_ tasks: [Task]) {
		isUrgentTask = true
		self.urgentTasks = tasks
	}
	
	func getUrgentTasks() -> [Task] {
		return self.urgentTasks
	}
	
	private func configureTaskCell(with task: Task, for tableView: UITableView, at indexPath: IndexPath) -> TaskCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
			print("Could not deque cell with identifier - \(TaskCell.identifier)")
			return TaskCell()
		}
		
		cell.taskTitle.text = task.title
		cell.taskStatus.text = task.status.description
		cell.taskDate.text = dateFormatter.string(from: task.date)
		
		return cell
	}
}

extension TasksDataDisplayManager: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	
		if isUrgentTask {
			return urgentTasks.count
		}
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		var cell = TaskCell()
		
		if isUrgentTask {
			let urgentTask = urgentTasks[indexPath.row]
			cell = configureTaskCell(with: urgentTask, for: tableView, at: indexPath)
		} else {
			let task = tasks[indexPath.row]
			cell = configureTaskCell(with: task, for: tableView, at: indexPath)
		}
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			let task = tasks[indexPath.row]
			let appDelegate = AppDelegate.getAppDelegate()
			let managedContext = appDelegate.persistentContainer.viewContext
			
			managedContext.delete(task)
			tasks.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			tableView.reloadData()
			
			do {
				try managedContext.save()
			} catch let error {
				print("Could not save \(error)")
			}
		}
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return !isUrgentTask
	}
}
