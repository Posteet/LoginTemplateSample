//
//  KakaoLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public class KakaoLogin: Login {
    
    private let authTypes: [KOAuthType]!
    
    internal init(authTypes: [KOAuthType]! = nil) {
        self.authTypes = authTypes;
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(KakaoLogin.kakaoSessionDidChangeWithNotification(_:)),
            name: KOSessionDidChangeNotification,
            object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func name() -> String {
        return LoginType.Kakao.rawValue
    }
    
    public func isLogin() -> Bool {
        return KOSession.sharedSession().isOpen()
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        var objAuthTypes: [AnyObject]! = nil
        
        if let authTypes = authTypes {
            objAuthTypes = [AnyObject]()
            
            for type in authTypes {
                objAuthTypes.append(type.rawValue)
            }
        }
        
        KOSession.sharedSession().openWithCompletionHandler({ (error) -> Void in
            guard let completion = completion else {
                return
            }
            
            if let error = error {
                return completion(nil, error)
            }
            
            KOSessionTask .meTaskWithCompletionHandler({ (result, error) -> Void in
                var userInfo: UserInfo! = nil
                if let user = result {
                    userInfo = UserInfo(ID: user.ID != nil ? user.ID!.stringValue : nil,
                        name: user.propertyForKey("nickname") as? String,
                        email: nil)
                }
                
                completion(userInfo, error)
            })
            }, authParams: nil, authTypes: objAuthTypes)
    }
    
    public func logout(completion: LogoutCompletion!) {
        KOSession.sharedSession().logoutAndCloseWithCompletionHandler { (success, error) -> Void in
            if let completion = completion {
                completion(success, error)
            }
        }
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        }
        
        return false
    }
    
    public func handleDidEnterBackground() {
        KOSession.handleDidEnterBackground()
    }
    
    public func handleDidBecomeActive() {
        KOSession.handleDidBecomeActive()
    }
    
    @objc public func kakaoSessionDidChangeWithNotification(notification: NSNotification!) {
        debugPrint("KakaoNotification : is login - \(isLogin())")
    }
    
}
