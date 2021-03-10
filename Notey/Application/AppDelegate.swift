//
//  AppDelegate.swift
//  Writey
//
//  Created by Arif Luthfiansyah on 21/02/21.
//

import SnapKit
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var navigationController = UINavigationController()
    var appDIContainer: AppDIContainer {
        return AppDIContainer(navigationController: self.navigationController)
    }
    var appFlowCoordinator: AppFlowCoordinator {
        return DefaultAppFlowCoordinator(navigationController: self.navigationController,
                                         presentationFactory: self.appDIContainer)
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        #if DEBUG
        print("NSHomeDirectory -> \(NSHomeDirectory())")
        #endif
        return true
    }

}

// MARK: UISceneSession Lifecycle Function
extension AppDelegate {
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

