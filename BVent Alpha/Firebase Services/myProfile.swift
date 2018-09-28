//
//  myProfile.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 28/06/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation

class MyProfile {
    var id: String
    var user: UserProfile
    
    init(id: String, user: UserProfile) {
        self.id = id
        self.user = user
    }
}
