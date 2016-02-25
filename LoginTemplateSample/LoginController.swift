//
//  LoginController.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 22..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

class LoginController {
    
    static private(set) var instance: Login! = LoginFactory.createLogin(.None)
    
    private init() {
    }
    
    class func setup(type: LoginType) {
        switch type {
        case .Naver:
            self.instance = LoginFactory.createLogin(type, title: "네이버 로그인", schemeUrl: "adobeone4login", authKey: "W2R5FeAAr59WAKuuMxJO", authScret: "nzAhmB6spE")
        default:
            self.instance = LoginFactory.createLogin(type)
        }
    }
    
}
