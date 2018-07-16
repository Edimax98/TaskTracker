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
	
	func showErrorAlert(with title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .cancel)
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}
	
	func showWarningAlert(with title: String?, message: String?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
			self.dismiss(animated: true, completion: nil)
		}
		alert.addAction(okAction)
		self.present(alert, animated: true, completion: nil)
	}

}
