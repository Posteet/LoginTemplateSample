//
//  FacebookLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation
import FBSDKLoginKit

public class FacebookLogin: Login {
    
    init() {
    }
    
    public func name() -> String {
        return LoginType.Facebook.rawValue
    }
    
    public func isLogin() -> Bool {
        return FBSDKAccessToken.currentAccessToken() != nil
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager .logInWithReadPermissions(["public_profile", "email"], fromViewController: parentViewController) { (result, error) -> Void in
            guard let completion = completion else {
                return
            }
            
            if let error = error {
                return completion(nil, error)
            }
            
            if result.isCancelled {
                return completion(nil, NSError(domain: FBSDKLoginErrorDomain, code: -1, userInfo: ["reason":"user cancelled."]))
            }
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                var userInfo: UserInfo! = nil
                if let user = result as? [String: String] {
                    userInfo = UserInfo(ID: user["id"], name: user["name"], email: user["email"])
                }
                
                completion(userInfo, error)
            })
            
        }
    }
    
    public func logout(completion: LogoutCompletion!) {
        FBSDKLoginManager().logOut()
        
        if let completion = completion {
            completion(true, nil)
        }
    }
    
    public func handleApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    public func handleDidEnterBackground() {
    }
    
    public func handleDidBecomeActive() {
        FBSDKAppEvents.activateApp()
    }
    
}