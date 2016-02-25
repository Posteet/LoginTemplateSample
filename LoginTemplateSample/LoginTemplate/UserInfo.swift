//
//  UserInfo.swift
//  LoginSample
//
//  Created by Thomas on 2016. 2. 23..
//  Copyright © 2016년 Thomas. All rights reserved.
//

import Foundation

public struct UserInfo {
    
    public let ID: String!
    public let name: String!
    public let email: String!
    
    internal init(ID: String!, name: String!, email: String!) {
        self.ID = ID
        self.name = name
        self.email = email
    }
}