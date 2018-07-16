
//  CreateTaskViewController.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import CoreData

class DetailedTaskViewController: UITableViewController {

	@IBOutlet weak var taskTitleTextView: UITextView!
	@IBOutlet weak var taskDateTextField: DateTextField!
	@IBOutlet weak var taskNoteTextView: UITextView!
	@IBOutlet weak var changeTaskStatusButton: UIButton!
	
	private var selectedTask: Task?
	private var wasAnythingChanged = false
	private var isThereAnyErorrs = false
	
	private let dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = DateFormat.dateWithoutTimeZone.description
		return df
	}()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }
	
	@IBAction func saveTaskButtonPressed(_ sender: Any) {
		
		if !areRequiredTextFieldsFilled() {
			showErrorAlert(with: nil, message: "Enter title and date".localized)
			return
		}
		
		if wasAnythingChanged && isUpdateModeOn() {
			update(task: selectedTask!)
		} else {
			saveTask()
		}
		
		if !isThereAnyErorrs {
			dismiss(animated: true, completion: nil)
		}
	}
	
	@IBAction func dateTextFieldEditingBegan(_ sender: UITextField) {
		
		let datePickerView: UIDatePicker = UIDatePicker()
		
		datePickerView.datePickerMode = .dateAndTime
		datePickerView.minimumDate = Date()
		sender.inputView = datePickerView
		datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
	}
	
	@IBAction func exitDetailedTaskView(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction func changeTaskStatusButtonPressed(_ sender: Any) {
		changeTaskStatus()
		if isTaskDoneNotOnTime(selectedTask!.date) {
			isThereAnyErorrs = true
			showWarningAlert(with: "Task must have be done earlier".localized, message: nil)
		} else {
			dismiss(animated: true, completion: nil)
		}
	}

	@IBAction func textFieldChanged(_ sender: Any) {
		wasAnythingChanged = true
	}
	
	@objc func datePickerValueChanged(sender: UIDatePicker) {
		taskDateTextField.text = dateFormatter.string(from: sender.date)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
	
	private func setupView() {
		
		if isUpdateModeOn() && selectedTask!.status != .done {
			changeTaskStatusButton.isHidden = false
			setTitleForChangeTaskStatusButton()
		} else {
			changeTaskStatusButton.isHidden = true
		}
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(tapGesture)
		
		fillTextFields(with: selectedTask)
	}
	
	private func isTaskDoneNotOnTime(_ taskDate: Date) -> Bool {
		return taskDate < Date()
	}
	
	private func changeTaskStatus() {
		
		let appDelegate = AppDelegate.getAppDelegate()
		let managedContext = appDelegate.persistentContainer.viewContext

		switch selectedTask!.status {
		case .new:
			selectedTask!.status = .inProcess
		case .inProcess:
			selectedTask!.status = .done
		case .done:
			break
		case .undefined:
			break
		}
		
		do {
			try managedContext.save()
		} catch {
			showErrorAlert(with: "Error".localized, message: "Could not save".localized)
			managedContext.rollback()
		}
	}
	
	private func setTitleForChangeTaskStatusButton() {
		
		switch selectedTask!.status {
		case .new:
			changeTaskStatusButton.setTitle("Start".localized, for: .normal)
		case .inProcess:
			changeTaskStatusButton.setTitle("Finish".localized, for: .normal)
		case .done:
			break
		case .undefined:
			break
		}
	}
	
	private func fillTextFields(with selectedTask: Task?) {
		
		guard let task = selectedTask else {
			print("Selected task is nil")
			return
		}
		
		taskTitleTextView.text = task.title
		taskDateTextField.text = dateFormatter.string(from: task.date)
		
		if let taskNote = task.note {
			taskNoteTextView.text = taskNote
		} else {
			taskNoteTextView.text = ""
		}
	}
	
	private func isUpdateModeOn() -> Bool {
		return selectedTask != nil
	}
	
	private func areRequiredTextFieldsFilled() -> Bool {
		return taskDateTextField.text != "" && taskTitleTextView.text != ""
	}
	
	private func saveTask() {
	
		let appDelegate = AppDelegate.getAppDelegate()
		
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
		
		task.title = taskTitleTextView.text!
		task.note = taskNoteTextView.text!
		task.status = .new
		task.date = formattedDate

		do {
			try managedContext.save()
			isThereAnyErorrs = false
		} catch let error as NSError {
			isThereAnyErorrs = true
			if error.code == NSValidationStringTooLongError && error.domain == NSCocoaErrorDomain {
				showErrorAlert(with: "Too much symbols".localized, message: "Max symbols for note - 300. Max symbols for title - 100".localized)
			} else {
				showErrorAlert(with: "Error".localized, message: "Could not save".localized)
			}
			managedContext.rollback()
		}
	}
	
	private func update(task: Task) {
		
		let appDelegate = AppDelegate.getAppDelegate()
		
		let managedContext = appDelegate.persistentContainer.viewContext
		
		guard let formattedDate = dateFormatter.date(from: taskDateTextField.text!) else {
			print("Could not get formatted date")
			return
		}
		
		task.title = taskTitleTextView.text!
		task.date = formattedDate
		task.note = taskNoteTextView.text!
		
		do {
			try managedContext.save()
			isThereAnyErorrs = false
		} catch let error as NSError {
			isThereAnyErorrs = true
			if error.code == NSValidationStringTooLongError && error.domain == NSCocoaErrorDomain {
				showErrorAlert(with: "Too much symbols".localized, message: "Max symbols for note - 300. Max symbols for title - 100".localized)
			} else {
				showErrorAlert(with: "Error".localized, message: "Could not save".localized)
			}
			managedContext.rollback()
		}
	}
}

// MARK: - TaskViewOutput
extension DetailedTaskViewController: TaskViewOutput {
	
	func sendSelectedTask(_ task: Task) {
		self.selectedTask = task
	}
}
