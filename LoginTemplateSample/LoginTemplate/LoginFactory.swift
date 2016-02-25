//
//  LoginFactory.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public class LoginFactory {
    
    class func createLogin(type: LoginType, title: String! = nil, schemeUrl: String! = nil, authKey: String! = nil, authScret: String! = nil) -> Login! {
        
        switch type {
        case .Kakao:
            return KakaoLogin()
        case .Naver:
            return NaverLogin(title: title!, schemeUrl: schemeUrl!, authKey: authKey!, authScret: authScret!)
        case .Facebook:
            return FacebookLogin()
        case .Instagram:
            return InstagramLogin()
        case .Google:
            return GoogleLogin()
        default:
            return NoLogin()
        }
    }
}

public enum LoginType: String {
    case None = "None"
    case Kakao = "Kakao"
    case Naver = "Naver"
    case Facebook = "Facebook"
    case Instagram = "Instagram"
    case Google = "Google"
}