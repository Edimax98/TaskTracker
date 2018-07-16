//
//  TodayViewController.swift
//  TodayExtension
//
//  Created by Даниил Смирнов on 15.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
	
	@IBOutlet weak var taskTitleLabel: UILabel!
	@IBOutlet weak var taskDateLabel: UILabel!
	
	private var dateFormatter: DateFormatter = {
		let df = DateFormatter()
		df.dateFormat = "MMM d, hh:mm"
		return df
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		
		if let taskTitle = UserDefaults(suiteName: "group.com.taskTracker")?.value(forKey: "urgentTaskTitle") as? String,
			let taskDate = UserDefaults(suiteName: "group.com.taskTracker")?.value(forKey: "urgentTaskDate") as? Date {
			taskTitleLabel.text = taskTitle
			taskDateLabel.text = dateFormatter.string(from: taskDate)
		} else {
			print("Could not get data")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		
		completionHandler(NCUpdateResult.newData)
	}
}









