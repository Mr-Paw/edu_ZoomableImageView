//
//  AppDelegate.swift
//  ScrollingAndZooming
//
//  Created by paw on 29.11.2020.
//  Copyright © 2020 paw. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static let previewInSwiftUI = true // flip this flag to preview the uikit version

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // storyboard is only useful for objective-c(AFAIK manual constraints in objc are pain in the ass), in swift it's easier to do it programmatically in my opinion
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = Self.previewInSwiftUI ? UIHostingController(rootView: ContentView()) : ViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

