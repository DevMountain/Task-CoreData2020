//
//  AppDelegate.swift
//  Task
//
//  Created by Caleb Hicks on 10/20/15.
//  Copyright © 2015 DevMountain. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func applicationWillResignActive(application: UIApplication) {
		do {
			try Stack.sharedStack.managedObjectContext.save()
		} catch let error as NSError {
			NSLog("Failed to save core data store: \(error)")
		}
	}
	
	func applicationWillTerminate(application: UIApplication) {
		do {
			try Stack.sharedStack.managedObjectContext.save()
		} catch let error as NSError {
			NSLog("Failed to save core data store: \(error)")
		}
	}
}

