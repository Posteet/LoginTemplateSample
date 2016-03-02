//
//  NaverLogin.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation
import AEXML
import NaverLoginSDK

public class NaverLogin: NSObject, Login, NaverThirdPartyLoginConnectionDelegate {
    
    private let loginConnection: NaverThirdPartyLoginConnection!
    private let operationQueue: NSOperationQueue
    
    private var loginCompletion: LoginCompletion!
    private weak var parentViewController: UIViewController!
    
    init(title: String, schemeUrl: String, authKey: String, authScret: String) {
        self.loginConnection = NaverThirdPartyLoginConnection.getSharedInstance()
        self.operationQueue = NSOperationQueue()
        
        loginConnection.appName = title
        loginConnection.serviceUrlScheme = schemeUrl
        loginConnection.consumerKey = authKey
        loginConnection.consumerSecret = authScret
        
        loginConnection.isInAppOauthEnable = true
        loginConnection.isNaverAppOauthEnable = true
    }
    
    public func name() -> String {
        return LoginType.Naver.rawValue
    }
    
    public func isLogin() -> Bool {
        return loginConnection.refreshToken != nil
    }
    
    public func login(parentViewController: UIViewController!, completion: LoginCompletion!) {
        self.loginCompletion = completion;
        self.parentViewController = parentViewController;
        
        loginConnection.delegate = self
        loginConnection.requestThirdPartyLogin()
    }
    
    public func logout(completion: LogoutCompletion!) {
        loginConnection.resetToken()
        
        if let completion = completion {
            completion(true, nil)
        }
    }
    
    public func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == loginConnection.serviceUrlScheme {
            if url.host == kCheckResultPage {
                let resultType: THIRDPARTYLOGIN_RECEIVE_TYPE = loginConnection.receiveAccessToken(url)
                if resultType == SUCCESS {
                    loginCompleted()
                } else {
                    loginFailed(NSError(domain: "Naver Login", code: Int(resultType.rawValue), userInfo: nil))
                }
            }
            
            return true
        }
        
        return false
    }
    
    func loginCompleted() {
        guard let completion = loginCompletion else {
            return
        }
        
        guard let url = NSURL(string: "https://openapi.naver.com/v1/nid/getUserProfile.xml") else {
            completion(nil, NSError(domain: "Naver Login", code: -1, userInfo: ["reason": "failed to get user profile."]))
            self.loginCompletion = nil
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL: url)
        let authValue = "Bearer \(loginConnection.accessToken)"
        urlRequest.setValue(authValue, forHTTPHeaderField: "Authorization")
        
        if #available(iOS 9, *) {
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: { [weak self] (data, response, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.onReceivedData(data, error: error)
                })
                })
            task.resume()
        } else {
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: operationQueue) { [weak self] (response, data, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.onReceivedData(data, error: error)
                })
            }
        }
    }
    
    func onReceivedData(data: NSData!, error: NSError!) {
        defer {
            self.loginCompletion = nil
        }
        
        guard let completion = loginCompletion else {
            return
        }
        
        guard let data = data else {
            return completion(nil, error)
        }
        
        var userInfo: UserInfo! = nil
        
        do {
            let xmlDoc = try AEXMLDocument(xmlData: data)
            if let root: AEXMLElement = xmlDoc.root["response"] {
                userInfo = UserInfo(ID: root["id"].stringValue, name: root["name"].stringValue, email: root["email"].stringValue)
            }
        } catch {
        }
        
        completion(userInfo, userInfo == nil ? NSError(domain: "Naver Login", code: -1, userInfo: ["reason": "xml parsing error.."]) : nil)
    }
    
    func loginFailed(error: NSError!) {
        if let completion = loginCompletion {
            completion(nil, error)
        }
        
        self.loginCompletion = nil
    }
    
    public func handleDidEnterBackground() {
    }
    
    public func handleDidBecomeActive() {
    }
    
    
    // MARK: - Naver Login Delegate
    
    @objc public func oauth20ConnectionDidOpenInAppBrowserForOAuth(request: NSURLRequest!) {
        if let presentViewController = self.parentViewController {
            let viewController = NLoginThirdPartyOAuth20InAppBrowserViewController(request: request);
            presentViewController.presentViewController(viewController, animated: false, completion: nil)
        }
    }
    
    @objc public func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        loginCompleted()
    }
    
    @objc public func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
    }
    
    @objc public func oauth20ConnectionDidFinishDeleteToken() {
    }
    
    @objc public func oauth20Connection(oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: NSError!) {
        loginFailed(error)
    }
    
}