//
//  GoogleLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 23..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public class GoogleLogin: NSObject, Login, GIDSignInDelegate, GIDSignInUIDelegate {
    struct Tokens { static var token: dispatch_once_t = 0 }
    
    weak private var parentViewController: UIViewController!
    private var loginCompletion: LoginCompletion!
    
    internal override init() {
        super.init()
        
        dispatch_once(&Tokens.token) {
            var configureError: NSError?
            GGLContext.sharedInstance().configureWithError(&configureError)
            assert(configureError == nil, "Error configuring Google services: \(configureError)")
        }
        
        GIDSignIn.sharedInstance().delegate = self
    }
    
    public func name() -> String {
        return LoginType.Google.rawValue
    }
    
    public func isLogin() -> Bool {
        return GIDSignIn.sharedInstance().hasAuthInKeychain()
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        self.loginCompletion = completion;
        
        GIDSignIn.sharedInstance().uiDelegate = self
        self.parentViewController = parentViewController
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func logout(completion: LogoutCompletion!) {
        GIDSignIn.sharedInstance().signOut()
        
        if let completion = completion {
            completion(true, nil)
        }
    }
    
    public func handleApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    public func handleDidEnterBackground() {
    }
    
    public func handleDidBecomeActive() {
    }
    
    // MARK: - Google sign-in
    @objc public func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        defer {
            self.loginCompletion = nil
        }
        
        guard let completion = loginCompletion else {
            return
        }
        
        if let error = error {
            return completion(nil, error)
        }
        
        completion(UserInfo(ID: user.userID, name: user.profile.name, email: user.profile.email), nil)
    }
    
    @objc public func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
    }
    
    public func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        parentViewController?.presentViewController(viewController, animated: true, completion: nil)
    }
    
    public func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        parentViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}