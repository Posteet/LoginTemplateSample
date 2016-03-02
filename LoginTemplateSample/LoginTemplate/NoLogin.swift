//
//  NoLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public class NoLogin: Login {
    
    internal init() {
    }
    
    public func name() -> String {
        return LoginType.None.rawValue
    }
    
    public func isLogin() -> Bool {
        return false
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        if let completion = completion {
            completion(nil, nil)
        }
    }
    
    public func logout(completion: LogoutCompletion!) {
        if let completion = completion {
            completion(true, nil)
        }
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return false
    }
    
    public func handleDidEnterBackground() {
    }
    
    public func handleDidBecomeActive() {
    }
    
}