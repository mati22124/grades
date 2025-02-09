//
//  gradesApp.swift
//  grades
//
//  Created by Mayank Tiku on 9/23/24.
//

import SwiftUI
import Firebase
import GoogleSignIn
import Shake

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      Shake.start(apiKey: "Myf0sDjz5icJ7HiHO90aQK09xytoD7vfRqSrAkuX71v7qRrA8SsFrXr")
      Shake.configuration.isCrashReportingEnabled = true
      FirebaseApp.configure()
      return true
  }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    
}


@main
struct gradesApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
