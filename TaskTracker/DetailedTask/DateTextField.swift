//
//  DateTextField.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 15.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

class DateTextField: UITextField {
	
	override func  canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
		if action == #selector(paste(_:)) {
			return false
		}
		return super.canPerformAction(action, withSender: sender)
	}
}
