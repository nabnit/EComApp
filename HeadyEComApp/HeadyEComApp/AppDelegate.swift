//
//  AppDelegate.swift
//  HeadyEComApp
//
//  Created by Patnaik, Nabnit [GCB-OT NE] on 5/30/19.
//  Copyright © 2019 Patnaik, Nabnit [GCB-OT NE]. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

extension UIViewController {
    // Create an activity indicator view
    func getAcitivtyIndicator() -> UIView {
        let viewForActivityIndicator = UIView()
        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        viewForActivityIndicator.backgroundColor = UIColor.white
        view.addSubview(viewForActivityIndicator)
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = self.view.center
        
        let loadingTextLabel = UILabel()
        loadingTextLabel.textColor = UIColor.black
        loadingTextLabel.text = "LOADING"
        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
        loadingTextLabel.sizeToFit()
        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
        viewForActivityIndicator.addSubview(loadingTextLabel)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.tag = 1
        viewForActivityIndicator.addSubview(activityIndicatorView)
        viewForActivityIndicator.alpha = 0.8
        return viewForActivityIndicator
    }
    
    // Show the activity indicator view
    func showActivityIndicator(activityView: UIView) {
        if let actV = view.viewWithTag(1) as? UIActivityIndicatorView {
            actV.startAnimating()
            self.view.addSubview(activityView)
        }
    }
    
    // Hide the activity indicator view
    func hideAcitivityIndicator(activityView: UIView) {
        if let actV = view.viewWithTag(1) as? UIActivityIndicatorView {
            actV.stopAnimating()
            activityView.removeFromSuperview()
        }
    }

    // Present the login view controller
    func navigateToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        self.present(controller, animated: false, completion: nil)
    }
    
    // Show alert view
    func showAlert(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Logout
    func logout() {
        self.navigationController?.popToRootViewController(animated: true)
        EComUtil.resetDataController()
        self.navigateToLoginScreen()
    }
}
