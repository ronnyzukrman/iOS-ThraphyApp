//
//  AppDelegate.swift
//  Therapy
//
//  Created by SIERRA on 12/11/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MMDrawerController
import NVActivityIndicatorView
import FBSDKLoginKit
import FBSDKCoreKit
import FacebookLogin
import GoogleSignIn
@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,NVActivityIndicatorViewable, GIDSignInDelegate {
    var window: UIWindow?
    var centerContainer =  MMDrawerController()
    var gmailuserdictionary = [String : Any]()
    var firstName = String()
    var lastName = String()
    var id = String()
    var type = String()
    var email = String()
    var gender = String()
    var userimage = String()
    var idToken = String()
    var loginType = String()
    var parms = [String:String]()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        iniSideMenu()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent //For Status bar to be white in color
        UINavigationBar.appearance().barTintColor = THEME_COLOR
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        //MARK: use for facebook integration
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //MARK: Initialize google sign-in
        GIDSignIn.sharedInstance().clientID = "928492001918-7jhg7keeqj9116jkvl5f6vu15qtqaksm.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    func iniSideMenu(){
        let mainstoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let  centerViewController = mainstoryBoard.instantiateViewController(withIdentifier: "Login_ViewController") as! Login_ViewController
        let  leftViewController = mainstoryBoard.instantiateViewController(withIdentifier: "SideMenuController") as! SideMenuController
        let leftsidenav = UINavigationController(rootViewController: leftViewController)
        let centnav = UINavigationController(rootViewController: centerViewController)
        centerContainer = MMDrawerController(center: centnav, leftDrawerViewController: leftsidenav)
        centerContainer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView
        centerContainer.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView
        window?.rootViewController = centerContainer
        window?.makeKeyAndVisible()
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
        let reachability = PMDReachabilityWrapper.sharedInstance()
        reachability?.monitorReachability()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
       if(url.scheme!.isEqual("fb295116931190572"))
        {
            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
       else if(url.scheme!.isEqual("com.googleusercontent.apps.928492001918-7jhg7keeqj9116jkvl5f6vu15qtqaksm"))
       {
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
      
        else{
            return true
        }
    }
    
    //    se
    private func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        let options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        print(options)
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!)
    {
        
    }
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            print(user)
            id = user.userID                  // For client-side use only!
            idToken = user.authentication.idToken // Safe to send to the server
            firstName = user.profile.name
            _ = user.profile.givenName
            email = user.profile.email
            userimage = "\(user.profile.imageURL(withDimension: 120) as URL)"
            self.loginType = "g"
            self.SocialLoginAPI()
            
        } else
        {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func SocialLoginAPI(){
        if userimage != ""{
            parms = ["name": firstName,
                      "email": email,
                      "login_type": loginType,
                      "social_id" : id,
                      "user_image": userimage,
                      "phone_no": "",
                      "address": "",
                      "dob":"",
                      "password":"",
                      "country_code":"",
                      "flag":"",
                      "image_type":"link"]
        }else{
             parms = ["name": firstName,
                          "email": email,
                          "login_type": loginType,
                          "social_id" : id,
                          "user_image": "http://therapy.gangtask.com/public/images/default.jpg",
                          "phone_no": "",
                          "address": "",
                          "dob":"",
                          "password":"",
                          "country_code":"",
                          "flag":"",
                          "image_type":"link"]
        }
        print(parms)
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.SocialLogin.caseValue, parameters: parms ) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                
            }
            else
            {
                let user_id = "\(dic.value(forKeyPath: "user_id") as! NSNumber)"
                let user_accessToken = dic.value(forKeyPath: "token") as! String
                UserDefaults.standard.set(user_id, forKey: "USER_ID")
                UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
                UserDefaults.standard.set("NotCheck" , forKey: "REMEMBER_ME")
                 UserDefaults.standard.set("socialLogin", forKey: "SOCAIL_LOGIN")
                UserDefaults.standard.synchronize()
                // Define identifier
                let notificationName = Notification.Name("GMAIL_NOTI")
                // Post notification
                NotificationCenter.default.post(name: notificationName, object: nil)
                
            }
            
        }
    }
    
}

