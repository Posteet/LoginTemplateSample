//
//  LoginController.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

class LoginController {
    
    static private(set) var instance: Login! = NoLogin()
    
    private init() {
    }
    
    class func setup(type: LoginType) {
        switch type {
        case .Kakao:
            self.instance = KakaoLogin()
        case .Naver:
            self.instance = NaverLogin(title: "네이버 로그인", schemeUrl: "adobeone4login", authKey: "W2R5FeAAr59WAKuuMxJO", authScret: "nzAhmB6spE")
        case .Facebook:
            self.instance = FacebookLogin()
        case .Instagram:
            self.instance = InstagramLogin()
        case .Google:
            self.instance = GoogleLogin()
        default:
            self.instance = NoLogin()
        }
    } 
}
