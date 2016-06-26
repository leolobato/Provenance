//
//  AppDelegate.swift
//  PeripheralVirtualGameControlleriOSSample
//
//  Created by Rob Reuss on 9/13/15.
//  Copyright © 2015 Rob Reuss. All rights reserved.
//

import UIKit
import VirtualGameController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // This is a hack to deal with a slowly responding keyboard display
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        self.window?.addSubview(textField)
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        textField.removeFromSuperview()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        
        // Just as an example, sending a pause signal to our Central as we enter background
        VgcManager.elements.pauseButton.value = 1.0
        VgcManager.peripheral.sendElementState(VgcManager.elements.pauseButton)
        
    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        // Letting the Central know we are back from background
        VgcManager.elements.pauseButton.value = 0.0
        VgcManager.peripheral.sendElementState(VgcManager.elements.pauseButton)
        
        // Reycle service browser
        VgcManager.peripheral.stopBrowsingForServices()
        VgcManager.peripheral.browseForServices()
        
    }

    func applicationWillTerminate(application: UIApplication) {

        VgcManager.peripheral.disconnectFromService()
    }


}

