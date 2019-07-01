//
//  AppDelegate.swift
//  PresentrExample
//
//  Created by Daniel Lozano on 5/23/16.
//  Copyright © 2016 danielozano. All rights reserved.
//

import UIKit
import Presentr

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Presentr
        customizePresentr()
        return true
    }
    
    private func customizePresentr() {
        // Presentr
        let appearance = PresentrAppearance.standard
        
        appearance.backgroundColor = .gray
        appearance.backgroundOpacity = 0.8
        
//        appearance.actionSheet.item.font = /* UIFont(name: "Lato-Bold", size: 12) ?? */ UIFont.boldSystemFont(ofSize: 12)
        let font = UIFont.boldSystemFont(ofSize: 12)
        if #available(iOS 11.0, *) {
            appearance.actionSheet.item.font = UIFontMetrics.init(forTextStyle: .caption1).scaledFont(for: font)
        } else {
            // Fallback on earlier versions
            appearance.actionSheet.item.font = font
        }
        appearance.actionSheet.item.textColor = .black
        appearance.actionSheet.item.height = 58
        let font15 = UIFont.boldSystemFont(ofSize: 15)
        if #available(iOS 11.0, *) {
            appearance.actionSheet.title.font = UIFontMetrics.init(forTextStyle: .caption1).scaledFont(for: font15)
        } else {
            // Fallback on earlier versions
            appearance.actionSheet.item.font = font15
        }
        let font12 = UIFont.systemFont(ofSize: 12)
        if #available(iOS 11.0, *) {
            appearance.actionSheet.title.messageTextFont = UIFontMetrics.init(forTextStyle: .caption1).scaledFont(for: font12)
        } else {
            // Fallback on earlier versions
            appearance.actionSheet.item.font = font12
        }
//        appearance.actionSheet.title.font = /* UIFont(name: "Lato-Bold", size: 15) ?? */ UIFont.boldSystemFont(ofSize: 15)
//        appearance.actionSheet.title.messageTextFont = /* UIFont(name: "Lato-Regular", size: 12) ?? */ UIFont.systemFont(ofSize: 12)
        
        appearance.alert.actionsAxis = .vertical
        appearance.alert.title.font = UIFont.systemFont(ofSize: 17)
        appearance.alert.body.font = UIFont.systemFont(ofSize: 15)
        appearance.alert.title.textColor = .darkGray
        appearance.alert.body.textColor = .black
        appearance.alert.backgroundColor = .gray
        appearance.alert.button.font = UIFont.systemFont(ofSize: 12)
        appearance.alert.button.textColor = .black
        appearance.alert.button.borderWidth = 0.5
        appearance.alert.button.borderColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        appearance.alert.button.cornerRadius = 4
        appearance.alert.defaultButton.font = UIFont.boldSystemFont(ofSize: 12)
        appearance.alert.defaultButton.cornerRadius = 4
        appearance.alert.destructiveButton.cornerRadius = 4
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
