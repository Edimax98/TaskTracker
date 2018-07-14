//
//  TaskStatus.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 13.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

enum TaskStatus: Int16 {
	case new = 0
	case inProcess = 1
	case done = 2
	case undefined = 3
	
	var description: String {
		switch self {
		case .inProcess:
			return "In process".localized
		case .done:
			return "Done".localized
		case .new:
			return "New".localized
		case .undefined:
			return "Uknown".localized
		}
	}
}
