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
}

extension TasksDataDisplayManager: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let task = tasks[indexPath.row]
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as? TaskCell else {
			print("Could not deque cell with identifier - \(TaskCell.identifier)")
			return UITableViewCell()
		}
		
		cell.taskTitle.text = task.title
		cell.taskStatus.text = task.status.description
		cell.taskDate.text = dateFormatter.string(from: task.date)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		
		if editingStyle == .delete {
			
			let task = tasks[indexPath.row]
			
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
				print("Could not cast to AppDelegate")
				return
			}
			
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
}
