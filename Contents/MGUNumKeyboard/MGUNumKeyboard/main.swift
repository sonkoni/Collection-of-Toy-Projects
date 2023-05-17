//
//  main.swift
//  MGURulerView
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit

var appDelegateClassName: String?
autoreleasepool { appDelegateClassName = NSStringFromClass(AppDelegate.self) }

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClassName)
