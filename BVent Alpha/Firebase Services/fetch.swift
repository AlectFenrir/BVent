//
//  fetch.swift
//  BVent Alpha
//
//  Created by jonathan jordy on 22/06/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation
import UIKit

struct ambilData{
    
    var benefit: String
    var bookmark: Bool
    var category: String
    var certification: Bool
    var confirmCode: String
    var cp: String
    var date: String
    var desc: String
    var done: Bool
    var enroll: Bool
    var location: String
    var price: String
    var sat: Int
    var time: String
    var title: String
    var timestamp: String
    var poster: String
    var imageUrl: String
    
    init(fetch: [String : Any]){
        
        benefit = fetch["benefit"] as? String ?? ""
        bookmark = fetch["bookmark"] as? Bool ?? false
        category = fetch["category"] as? String ?? ""
        certification = fetch["certification"] as? Bool ?? false
        confirmCode = fetch["confirmCode"] as? String ?? ""
        cp = fetch["cp"] as? String ?? ""
        date = fetch["date"] as? String ?? ""
        desc = fetch["desc"] as? String ?? ""
        done = fetch["done"] as? Bool ?? false
        enroll = fetch["enroll"] as? Bool ?? false
        location = fetch["location"] as? String ?? ""
        price = fetch["price"] as? String ?? ""
        sat = fetch["sat"] as? Int ?? 0
        time = fetch["time"] as? String ?? ""
        title = fetch["title"] as? String ?? ""
        timestamp = fetch["timestamp"] as? String ?? ""
        poster = fetch["poster"] as? String ?? ""
        imageUrl = fetch["imageUrl"] as? String ?? ""
        
    }
    
}
