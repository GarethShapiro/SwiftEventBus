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
* A plain old UIViewController is supplied as rootViewController so that none of the application code runs while the tests do.
* See main.swift for how we get here.
*
**/
class TestAppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

		self.window = UIWindow(frame:UIScreen.main.bounds) as UIWindow?

		if let window = self.window{

			// Simply add a stub UIViewController to the window and go.
			window.rootViewController = UIViewController()
			window.rootViewController?.view.frame = window.frame

			window.makeKeyAndVisible()

		}

		// Override point for customization after application launch.
		return true
	}
}
