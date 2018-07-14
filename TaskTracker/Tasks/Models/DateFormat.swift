//
//  DateFormat.swift
//  TaskTracker
//
//  Created by Даниил Смирнов on 14.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import Foundation

enum DateFormat: CustomStringConvertible {
	
	case day
	case date
	case time
	case fullDate
	case dateWithoutTimeZone
	
	var description: String {
		
		switch self {
		case .date:
			return "yyyy.MM.dd"
		case .time:
			return "HH:mm:ss"
		case .fullDate:
			return "yyyy.MM.dd HH:mm:ss zzz"
		case .dateWithoutTimeZone:
			return "MMM d, hh:mm"
		case .day:
			return "d"
		}
	}
}
