//
//  Extensions.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import UIKit

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}

extension UIViewController {
	
	func showAlert(with title: String, message: String, actions: String...) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		for (_, option) in actions.enumerated() {
			alertController.addAction(UIAlertAction(title: option, style: .default, handler: nil))
		}
		self.present(alertController, animated: true, completion: nil)
	}
}
