//
//  main.swift
//  SwiftEventBusExample
//
//  Created by Gareth Shapiro on 11/02/2019.
//  Copyright © 2019 Gareth Shapiro. All rights reserved.
//

import Foundation
import UIKit

/**
*
*	TestAppDelegate allows for headless testing, if testing is what's required.
*
*/
if(NSClassFromString("XCTestCase") == nil) {

	UIApplicationMain(
		CommandLine.argc,
		CommandLine.unsafeArgv,
		NSStringFromClass(UIApplication.self),
		NSStringFromClass(AppDelegate.self)
	)

} else {

	UIApplicationMain(
		CommandLine.argc,
		CommandLine.unsafeArgv,
		NSStringFromClass(UIApplication.self),
		NSStringFromClass(TestAppDelegate.self)
	)
}
