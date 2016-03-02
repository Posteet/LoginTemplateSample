//
//  Login.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public typealias LoginCompletion = (UserInfo!, NSError!) -> Void
public typealias LogoutCompletion = (Bool, NSError!) -> Void

public protocol Login {
    func name() -> String
    
    func isLogin() -> Bool
    func login(parentViewController: UIViewController!, completion: LoginCompletion!)
    func logout(completion: LogoutCompletion!)
    
    func handleApplication(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    func handleDidEnterBackground()
    func handleDidBecomeActive()
}

public enum LoginType: String {
    case None = "None"
    case Kakao = "Kakao"
    case Naver = "Naver"
    case Facebook = "Facebook"
    case Instagram = "Instagram"
    case Google = "Google"
}
