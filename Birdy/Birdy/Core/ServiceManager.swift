
//
//  ServiceManager.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/7/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

let baseUrl = "https://jk208.host.cs.st-andrews.ac.uk/birdwatch"

class ServiceManager: NSObject {


    class func getAllBirds(callback:(([Bird],NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/birdlist"

        LoadRequest(urlString, success: { (data) in
            var birds:[Bird] = []
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                guard let birdsArray :NSArray = JSON as? NSArray else {
                    if callback != nil { callback!([],NSError(domain: "in-app", code: 1000, userInfo: [NSLocalizedDescriptionKey:"json not array"]))}
                    return
                }
                for dict in birdsArray {
                    birds.append(Bird(dataDictionary: dict as! NSDictionary))
                }
                if callback != nil { callback!(birds,nil)}
            } catch let error as NSError {
                print("\(error)")
                if callback != nil { callback!([],error)}
            }
        }) { (error) in
            if callback != nil { callback!([],error)}
        }
    }

    class func getRandomBird(callback:((bird:Bird?,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/randomBird"

        LoadRequest(urlString, success: { (data) in
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            }) { (error) in
                print("error \(error)")
                if callback != nil { callback!(bird: nil,error: error)}
        }
    }

    class func login(login:String, password:String,callback:((success:Bool,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/users/login/\(login)/\(password)"
        LoadRequest(urlString, success: { (data) in
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String
            let result = stringToBool(str)
            if callback != nil { callback!(success:result,error:nil)}
            }) { (error) in
                if callback != nil { callback!(success:false,error:error)}
        }
    }

    class func registerUser() {

    }

    class func getUserList() {
        let urlString = "\(baseUrl)/users/userlist"

        LoadRequest(urlString, success: { (data) in
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("users \(str)")
            }) { (error) in
                print("error \(error)")
        }
    }
}

private func LoadRequest(urlString:String,success:((NSData?)->())?,fail:((NSError?)->())?) {
    let request = NSURLRequest(URL: NSURL(string: urlString)!)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if error == nil {
                    if success != nil { success!(data!) }
                } else {
                    if fail != nil { fail!(error!) }
                }
            })
            }.resume()
    })
}

class Bird : NSObject {
    var birdId:String! = ""
    var image:String! = ""
    var scientificname:String! = ""
    var commonname:String! = ""
    var latitude:Double! = 0.0
    var longitude:Double! = 0.0
    var date:String! = ""
    var weather:String! = ""
    var status:String! = ""
    var votes:[String:AnyObject!]! = [:]
    var seenbyuser:[String]! = []
    var owner:String! = ""
    var comments:String! = ""

    init(dataDictionary:NSDictionary) {
        super.init()
        self.birdId = dataDictionary["_id"] as? String ?? ""
        self.image = dataDictionary["image"] as? String ?? ""
        self.scientificname = dataDictionary["scientificname"] as? String ?? ""
        self.commonname = dataDictionary["commonname"] as? String ?? ""
        if let locArr = dataDictionary["location"] as? NSArray {
            if let lat = locArr[0] as? Double {
                self.latitude = lat
            }
            if let long = locArr[1] as? Double {
                self.longitude = long
            }
        }

        self.date = dataDictionary["date"] as? String ?? ""
        self.weather = dataDictionary["weather"] as? String ?? ""
        self.status = dataDictionary["status"] as? String ?? ""
        self.votes = dataDictionary["votes"] as? [String:AnyObject!] ?? [:]
        self.seenbyuser = dataDictionary["seenbyuser"] as? [String] ?? []
        self.owner = dataDictionary["owner"] as? String ?? ""
        self.comments = dataDictionary["comments"] as? String ?? ""

    }
}