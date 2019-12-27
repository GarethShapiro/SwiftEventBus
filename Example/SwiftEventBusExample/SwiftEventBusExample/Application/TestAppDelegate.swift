//
//  TestAppDelegate.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 11/02/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//
import UIKit

/**
*
* An Application Delegate which faciliates headless unit tests.
* See main.swift for how we get here.
*
**/
class TestAppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {


		// Override point for customization after application launch.
		return true
	}
}
