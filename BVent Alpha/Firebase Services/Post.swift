//
//  Post.swift
//  BVent Alpha
//
//  Created by Rayhan Martiza Faluda on 25/05/18.
//  Copyright © 2018 Rayhan Martiza Faluda. All rights reserved.
//

import Foundation

class Post
{
    var id:String
    var author:UserProfile
    var text:String
    var timestamp:Double
    var eventTitle: String
    var eventPrice: String
    var eventDate: String
    var eventLocation: String
    var eventDescription: String
    var eventImageURL: URL
    
    init(id:String, author:UserProfile,text:String,timestamp:Double, eventTitle: String, eventPrice: String, eventDate: String, eventLocation: String, eventDescription: String, eventImageURL: URL) {
        self.id = id
        self.author = author
        self.text = text
        self.timestamp = timestamp
        self.eventTitle = eventTitle
        self.eventPrice = eventPrice
        self.eventDate = eventDate
        self.eventLocation = eventLocation
        self.eventDescription = eventDescription
        self.eventImageURL = eventImageURL
    }
}
