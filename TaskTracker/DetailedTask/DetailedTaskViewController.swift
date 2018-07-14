//
//  CreateTaskViewController.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import CoreData

class DetailedTaskViewController: UITableViewController {

	@IBOutlet weak var taskTitleTextField: UITextField!
	@IBOutlet weak var taskDateTextField: UITextField!
	@IBOutlet weak var taskNoteTextField: UITextField!
	
	private var selectedTask: Task?
	private var wasAnythingChanged = false
	
	private let dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = DateFormat.dateWithoutTimeZone.description
		return df
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	@IBAction func dateTextFieldEditingBegan(_ sender: UITextField) {
		
		let datePickerView: UIDatePicker = UIDatePicker()
		
		datePickerView.datePickerMode = .dateAndTime
		sender.inputView = datePickerView
		datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
	}
	
	@objc func datePickerValueChanged(sender: UIDatePicker) {
		taskDateTextField.text = dateFormatter.string(from: sender.date)
	}
	
	private func setupView() {
		
		taskDateTextField.placeholder = "Enter a date".localized
		taskNoteTextField.placeholder = "Enter a note for task".localized
		taskTitleTextField.placeholder = "Enter a title".localized
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tapGesture)
		
		fillTextFields(with: selectedTask)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	private func fillTextFields(with selectedTask: Task?) {
		
		guard let task = selectedTask else {
			print("Selected task is nil")
			return
		}
		
		taskTitleTextField.text = task.title
		taskDateTextField.text = dateFormatter.string(from: task.date)
		
		if let taskNote = task.note {
			taskNoteTextField.text = taskNote
		} else {
			taskNoteTextField.text = ""
		}
	}
	
	func isUpdateModeOn() -> Bool {
		return selectedTask != nil
	}
	
	@IBAction func exitDetailedTaskView(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func saveTaskButtonPressed(_ sender: Any) {
		
		if wasAnythingChanged && isUpdateModeOn() {
			update(task: selectedTask!)
		} else {
			saveTask()
		}
		dismiss(animated: true, completion: nil)
	}

	private func saveTask() {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			print("Could not cast to AppDelegate")
			return
		}
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else {
			print("Could not get entity")
			return
		}
		
		guard let task = NSManagedObject(entity: entity, insertInto: managedContext) as? Task else {
			print("Could not cast NSManagedObject to Task")
			return
		}
	
		guard let formattedDate = dateFormatter.date(from: taskDateTextField.text!) else {
			print("Could not get formatted date")
			return
		}
		
		task.title = taskTitleTextField.text!
		task.note = taskNoteTextField.text!
		task.status = .new
		task.date = formattedDate

		do {
			try managedContext.save()
		} catch let error {
			print("Could not save. \(error)")
		}
	}
	
	private func update(task: Task) {
		
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
			print("Could not cast to AppDelegate")
			return
		}

		let managedContext = appDelegate.persistentContainer.viewContext
		
		guard let formattedDate = dateFormatter.date(from: taskDateTextField.text!) else {
			print("Could not get formatted date")
			return
		}
		
		task.title = taskTitleTextField.text!
		task.date = formattedDate
		task.note = taskNoteTextField.text!
		task.status = .new
		
		do {
			try managedContext.save()
		} catch let error {
			print("Could not save. \(error)")
		}
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func textFieldChanged(_ sender: Any) {
		wasAnythingChanged = true
	}
}

// MARK: - TaskViewOutput
extension DetailedTaskViewController: TaskViewOutput {
	
	func sendSelectedTask(_ task: Task) {
		self.selectedTask = task
	}
}
