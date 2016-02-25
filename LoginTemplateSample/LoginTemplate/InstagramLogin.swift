//
//  InstagramLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 23..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation
import SafariServices
import InstagramKit

public class InstagramLogin: NSObject, Login, SFSafariViewControllerDelegate {
    
    private let instagramEngine: InstagramEngine
    private var webViewController: UIViewController!
    private var loginCompletion: LoginCompletion!
    
    internal override init() {
        self.instagramEngine = InstagramEngine.sharedEngine()
        
        super.init()
    }
    
    public func name() -> String {
        return LoginType.Instagram.rawValue
    }
    
    public func isLogin() -> Bool {
        return InstagramEngine.sharedEngine().isSessionValid()
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        self.loginCompletion = completion
        let authUrl = InstagramEngine.sharedEngine().authorizationURL()
        
        if #available(iOS 9, *) {
            webViewController = SFSafariViewController(URL: authUrl)
            (webViewController as! SFSafariViewController).delegate = self
        } else {
            UIApplication.sharedApplication().openURL(authUrl)
        }
        
        if let webViewController = webViewController {
            parentViewController.presentViewController(webViewController, animated: true, completion: nil)
        }
    }
    
    public func logout(completion: LogoutCompletion!) {
        instagramEngine.logout()
        
        if let completion = completion {
            completion(true, nil)
        }
    }
    
    public func handleApplication(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) {
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        defer {
            if self.webViewController != nil {
                self.webViewController.dismissViewControllerAnimated(true, completion: nil)
                self.webViewController = nil
            }
        }
        
        do {
            try instagramEngine.receivedValidAccessTokenFromURL(url)
            loginCompleted()
            return true
        } catch {
            onReceivedUser(nil, error: NSError(domain: "Instagram Login", code: -1, userInfo: ["reason": "failed to get access token."]))
        }
        
        return false
    }
    
    func loginCompleted() {
        guard let _ = loginCompletion else {
            return
        }
        
        instagramEngine.getSelfUserDetailsWithSuccess({ [weak self] (user) -> Void in
            self?.onReceivedUser(user, error: nil)
            }) { [weak self] (error, code) -> Void in
                self?.onReceivedUser(nil, error: error)
        }
    }
    
    func onReceivedUser(user: InstagramUser!, error: NSError!) {
        defer {
            self.loginCompletion = nil
        }
        
        guard let completion = loginCompletion else {
            return
        }
        
        guard let user = user else {
            return completion(nil, error)
        }
        
        completion(UserInfo(ID: user.username, name: user.fullName, email: nil), nil)
    }
    
    public func handleDidEnterBackground() {
    }
    
    public func handleDidBecomeActive() {
    }
    
    @available(iOS 9, *)
    @objc public func safariViewControllerDidFinish(controller: SFSafariViewController) {
        self.webViewController = nil
    }
    
}