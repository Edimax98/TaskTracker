//
//  Task+CoreDataClass.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {
	
	@NSManaged var title: String
	@NSManaged var date: Date
	@NSManaged var note: String?
	@NSManaged private var statusValue: Int16
	
	var status: TaskStatus {
		get {
			guard let status = TaskStatus(rawValue: statusValue) else {
				return .undefined
			}
			return status
		}
		set {
			self.statusValue = newValue.rawValue
		}
	}
}
