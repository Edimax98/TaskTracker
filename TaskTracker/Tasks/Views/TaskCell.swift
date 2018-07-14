//
//  TaskCell.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
	
	@IBOutlet weak var taskTitle: UILabel!
	@IBOutlet weak var taskDate: UILabel!
	@IBOutlet weak var taskStatus: UILabel!
	
	static var identifier: String {
		return "TaskCell"
	}
}
