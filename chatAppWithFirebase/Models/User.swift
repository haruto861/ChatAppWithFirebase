//
//  User.swift
//  chatAppWithFirebase
//
//  Created by 松島悠人 on 2021/03/23.
//

import Foundation
import Firebase

class User {

    let email: String
    let userName: String
    let createdAt:Timestamp
    let profileImageUrl: String

    init(dic: [String:Any]) {
        self.email = dic["email"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.profileImageUrl = dic["profileImageUrl"] as? String ?? ""

    }
    
}
