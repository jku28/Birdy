//
//  ServiceManager.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/7/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

let baseUrl = "https://jk208.host.cs.st-andrews.ac.uk/birdwatch/"

class ServiceManager: NSObject {


    class func getAllBirds() -> [Bird] {
        let birds:[Bird] = []

        let urlString = "\(baseUrl)birds"


        return birds
    }
}

class Bird : NSObject {
    var image:String! = ""
    var scientificname:String! = ""
    var commonname:String! = ""
    var location:String! = ""
    var date:String! = ""
    var weather:String! = ""
    var status:String! = ""
    var votes:String! = ""
    var seenbyuser:String = ""
    var owner:String! = ""
    var comments:String! = ""

    init(jsonString:String) {
        super.init()

    }
}