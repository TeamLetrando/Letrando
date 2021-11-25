//
//  AppDelegate.swift
//  Letrando
//
//  Created by Ronaldo Gomes on 20/11/20.
// swiftlint:disable all

import UIKit
import CoreData
import ARKit
import AVFoundation
import SoundsKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 3.0)
        let isFirstLaunch = (UserDefaults.standard.value(forKey: "FirstLaunch") as? Bool) ?? false
        UserDefaults.standard.set(true, forKey: "Launch")
        if !isFirstLaunch {
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.firstLaunch.rawValue)
            UserDefaults.standard.set(true, forKey: UserDefaultsKey.firstSound.rawValue)
            SoundsKit.setKeyAudio(true)
        }

//        guard ARWorldTrackingConfiguration.isSupported else {
//            fatalError("""
//                ARKit is not available on this device. For apps that require ARKit
//                for core functionality, use the `arkit` key in the key in the
//                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
//                the app from installing. (If the app can't be installed, this error
//                can't be triggered in a production scenario.)
//                In apps where AR is an additive feature, use `isSupported` to
//                determine whether to show UI for launching AR experiences.
//            """) // For details, see https://developer.apple.com/documentation/arkit
//        }
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(granted, _ ) in
            if granted {
                print("User gave permissions for local notifications")
            }
        }
        
        let notification = NotificationsController()
        notification.schenduleNotification()
        
        return true
    }
    var myOrientation: UIInterfaceOrientationMask = .portrait
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }

    
//    func applicationWillResignActive(_ application: UIApplication) {
//        if let viewController = self.window?.rootViewController as? SearchViewController {
//            viewController.blurView.isHidden = false
//        }
//    }
//    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        if let viewController = self.window?.rootViewController as? SearchViewController {
//            viewController.blurView.isHidden = true
//        }
 //   }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if !SoundsKit.isFinishOnboarding() && !UserDefaults.standard.bool(forKey: UserDefaultsKey.firstLaunch.rawValue) {
            SoundsKit.audioIsOn() ? try? SoundsKit.playBackgroundLetrando() : SoundsKit.stop()
        }
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        if !SoundsKit.isFinishOnboarding() && !UserDefaults.standard.bool(forKey: UserDefaultsKey.firstLaunch.rawValue) {
            SoundsKit.audioIsOn() ? try? SoundsKit.playBackgroundLetrando() : SoundsKit.stop()
        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Letrando")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //Permite a chamada da variavel de forma mais simples
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        let viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        return viewContext
    }

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
