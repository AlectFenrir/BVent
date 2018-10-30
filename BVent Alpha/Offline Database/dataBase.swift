
//  dataBase.swift
//  BVent

import UIKit

//var point: Int = 0

struct kumpulanData {
    
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
    var postId: String
    
    static var datas : [kumpulanData] = []
    static var myPosts : [kumpulanData] = []
    
    static func fetch()-> [kumpulanData]{
        //        var ft: [kumpulanData] = []
        //
        //        //Business
        //        ft.append(kumpulanData(benefit:"3 SAT point", bookmark: true, category: "Business", certification: true, confirmCode: "bijoex31", cp: "081293178988", date: "February 6th-7th 2018", desc:
        //            "Come and Join Binus job expo 31 will be held on Tuesday,March 6th-Wednesday,March 7th 2018 from 09.00-16.00 PM Let find a job together.", done: false, enroll: false, location: "Binus Alam sutera, Binus Anggrek,Binus JWC", price: "20.000", sat: 3, time: "09.00-16.00", title: "BINUS JOB EXPO  31",imageUrl: ""))
        //
        //
        return datas
    }
    
}
