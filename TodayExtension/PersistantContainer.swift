//
//  PersistantContainer.swift
//  TodayExtension
//
//  Created by Даниил Смирнов on 16.07.2018.
//  Copyright © 2018 Даниил Смирнов. All rights reserved.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
	
	override class func defaultDirectoryURL() -> URL {
		return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.taskTracker")!
	}
	
	override init(name: String, managedObjectModel model: NSManagedObjectModel) {
		super.init(name: name, managedObjectModel: model)
	}
}
