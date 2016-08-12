
//
//  ServiceManager.swift
//  Birdy
//
//  Created by Vladimir Yevdokimov on 8/7/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit
import Alamofire

let baseUrl = "https://jk208.host.cs.st-andrews.ac.uk/birdwatch"


class ServiceManager: NSObject {

    static var loggedUser:User?
    static var users:[User] = []

    //MARK: - Auth and User

    class func login(login:String, password:String,callback:((success:Bool,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/users/login/\(login)/\(password)"
        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            if let str = NSString(data: data!, encoding: NSUTF8StringEncoding) as? String {
                if str.containsString("403") {
                    if callback != nil { callback!(success:false,error:NSError(domain: "in-app", code: 10001, userInfo: [NSLocalizedDescriptionKey : "Forbidden (403)"]))}
                    return
                } else if str.containsString("502") {
                    if callback != nil { callback!(success:false,error:NSError(domain: "in-app", code: 10001, userInfo: [NSLocalizedDescriptionKey : "Bad gateway (502)"]))}
                    return
                } else if str.containsString("504") {
                    if callback != nil { callback!(success:false,error:NSError(domain: "in-app", code: 10001, userInfo: [NSLocalizedDescriptionKey : "Gateway Time-out (504)"]))}
                    return
                }

                let result = stringToBool(str)
                if result {
                    for user in users {
                        if user.userName == login {
                            loggedUser = user
                            break
                        }
                    }

                    if callback != nil { callback!(success:result,error:nil)}
                } else {
                    if callback != nil { callback!(success:false,error:NSError(domain: "server", code: 10001, userInfo: [NSLocalizedDescriptionKey : "Please check credentials"]))}
                }
            } else {
                if callback != nil { callback!(success:false,error:nil)}
            }
        }) { (error) in
            if callback != nil { callback!(success:false,error:error)}
        }
    }

    class func registerNew(user:User, callback:((success:Bool,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/users/adduser"

        LoadRequest(urlString, method: nil, uploadData: user.uploadData(), success: { (data) in

            loggedUser = user

            if callback != nil { callback!(success:true,error:nil) }

            }) { (error) in
                if callback != nil { callback!(success:false,error:error) }
        }
    }

    class func getUserList() {
        let urlString = "\(baseUrl)/users/userlist"

        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            users = []
            print("users \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                guard let usersArray :NSArray = JSON as? NSArray else {
                    return
                }
                for dict in usersArray {
                    users.append(User(dataDictionary: dict as! NSDictionary))
                }

            } catch let error as NSError {
                print("\(error)")
            }
        }) { (error) in
            print("error \(error)")
        }
    }

    class func updatePassword (newPassword:String, callback:((success:Bool,error:NSError?)->())?) {
        ///changepassword/:username/:password
        let urlString = "\(baseUrl)/users/changepassword/\(loggedUser!.userId)/\(newPassword)"
        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("pass updated \(str)")
            if callback != nil { callback!(success:true,error:nil) }
        }) { (error) in
            print("error \(error)")
            if callback != nil { callback!(success:false,error:error) }
        }
    }
    //MARK: - Birds

    class func getAllBirds(callback:(([Bird],NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/birdlist"

        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            var birds:[Bird] = []
            print("got birds \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
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

    class func getBirdsList(callback:(([Bird],NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/birdlist/\(loggedUser!.userId)"

        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            var birds:[Bird] = []
            print("got birds \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
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
        let urlString = "\(baseUrl)/birds/randombird/\(loggedUser!.userId)"
        print(loggedUser!.userId)
        print(loggedUser!.userName)

        LoadRequest(urlString, method: nil, uploadData:nil, success: { (data) in
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                guard let birdsArray :NSArray = JSON as? NSArray else {
                    if callback != nil { callback!(bird: nil,error: NSError(domain: "in-app", code: 1000, userInfo: [NSLocalizedDescriptionKey:"json not array"]))}
                    return
                }
                let bird = Bird(dataDictionary: birdsArray.firstObject as! NSDictionary)
                if callback != nil { callback!(bird: bird,error: nil)}
            } catch let error as NSError {
                print("\(error)")
                if callback != nil { callback!(bird: nil,error: error)}
            }
            }, fail: {(error) in
                if callback != nil { callback!(bird: nil,error: error)}
        })
    }

    class func updateBird(birdId:String, vote:String, callback:((result:Bool,error:NSError?)->())?) {
        let encVote = vote.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        let urlString = "\(baseUrl)/birds/updatebird/\(birdId)/\(encVote!)/\(loggedUser!.userId)"
        LoadRequest(urlString, method: nil,uploadData: nil, success: { (data) in
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("vote res \(str)")
            if callback != nil { callback!(result: true,error: nil)}

        }) { (error) in
            if callback != nil { callback!(result: false,error: error)}
        }
    }

    class func create(bird:Bird, callback:((success:Bool,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/addbird"

        LoadRequest(urlString, method: nil, uploadData: bird.uploadData(), success: { (data) in

            if callback != nil { callback!(success:true,error:nil) }

        }) { (error) in
            if callback != nil { callback!(success:false,error:error) }
        }
    }

    class func delete(birdId:String, callback:((success:Bool,error:NSError?)->())?) {
        let urlString = "\(baseUrl)/birds/deletebird/\(birdId)"

        LoadRequest(urlString, method: "DELETE", uploadData: nil, success: { (data) in

            if callback != nil { callback!(success:true,error:nil) }

        }) { (error) in
            if callback != nil { callback!(success:false,error:error) }
        }
    }
}

//MARK: - Global

private func LoadRequest(urlString:String, method:String?, uploadData:AnyObject?,success:((NSData?)->())?,fail:((NSError?)->())?) {
    let encodedStr = urlString//.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) as! String

    var alaMethod = Method.GET
    if method == "POST" {
        alaMethod = Method.POST
    } else if method == "DELETE" {
        alaMethod = Method.DELETE
    }

    if uploadData != nil {
        Alamofire.request(.POST, encodedStr, parameters: uploadData as? [String:AnyObject], encoding: .JSON, headers: ["Content-Type":"application/json"]).responseData(completionHandler: { (resp) in
            if resp.result.error == nil {
                if success != nil { success!(resp.data!) }
            } else {
                if fail != nil { fail!(resp.result.error!) }
            }
        })
    } else {
        Alamofire.request(alaMethod, encodedStr).responseData { (resp) in
            if resp.result.error == nil {
                if success != nil { success!(resp.data!) }
            } else {
                if fail != nil { fail!(resp.result.error!) }
            }
        }
    }


}

func uploadImage(uploadData:NSData, callback:((success:Bool,error:NSError?)->())?) {
    let encodedStr = "\(baseUrl)/photos/upload"

    Alamofire.upload(.POST, encodedStr, data: uploadData).responseData { (resp) in

    }


}

private func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    let body = NSMutableData();

    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
    }

    let filename = "user-profile.png"

    let mimetype = "image/png"

    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimetype)\r\n\r\n")
    body.appendData(imageDataKey)
    body.appendString("\r\n")



    body.appendString("--\(boundary)--\r\n")
    
    return body
}


private func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().UUIDString)"
}

//MARK: - Additional classes

class Bird : NSObject {
    var birdId:String! = ""
    var image:String! = ""
    var scientificname:String! = ""
    var commonname:String! = ""
    var latitude:Double! = 0.0
    var longitude:Double! = 0.0
    var date:String! = ""
    var weather:String! = ""
    var status:String! = "unverified"
    var votes:[[AnyObject!]]! = []
    var seenbyuser:[String]! = []
    var owner:String! = ""
    var comments:String! = ""

    override init() {
        super.init()
    }
    
    init(dataDictionary:NSDictionary) {
        super.init()
        self.birdId = dataDictionary[BirdKey.Id.rawValue] as? String ?? ""
        self.image = dataDictionary[BirdKey.Image.rawValue] as? String ?? ""
        self.scientificname = dataDictionary[BirdKey.ScientificName.rawValue] as? String ?? ""
        self.commonname = dataDictionary[BirdKey.CommonName.rawValue] as? String ?? ""
        if let locArr = dataDictionary[BirdKey.Location.rawValue] as? NSArray {
            if let lat = locArr[0] as? Double {
                self.latitude = lat
            }
            if let long = locArr[1] as? Double {
                self.longitude = long
            }
        }

        self.date = dataDictionary[BirdKey.Date.rawValue] as? String ?? ""
        self.weather = dataDictionary[BirdKey.Weather.rawValue] as? String ?? ""
        self.status = dataDictionary[BirdKey.Status.rawValue] as? String ?? ""
        self.votes = dataDictionary[BirdKey.Votes.rawValue] as? [[AnyObject!]] ?? []
        self.seenbyuser = dataDictionary[BirdKey.SeenByUser.rawValue] as? [String] ?? []
        self.owner = dataDictionary[BirdKey.Owner.rawValue] as? String ?? ""
        self.comments = dataDictionary[BirdKey.Comments.rawValue] as? String ?? ""
    }

    func uploadData()-> AnyObject? {
        let dataDict = [BirdKey.Image.rawValue : self.image,
                        BirdKey.CommonName.rawValue : self.commonname,
                        BirdKey.ScientificName.rawValue : self.scientificname,
                        BirdKey.Location.rawValue : [self.latitude,self.longitude],
                        BirdKey.Date.rawValue : self.date,
                        BirdKey.SeenByUser.rawValue : self.seenbyuser,
                        BirdKey.Weather.rawValue : self.weather,
                        BirdKey.Owner.rawValue : self.owner,
                        BirdKey.Comments.rawValue : self.comments,
                        BirdKey.Status.rawValue : self.status,
                        BirdKey.Votes.rawValue : self.votes
                        ]

//        do {
//            let data = try NSJSONSerialization.dataWithJSONObject(dataDict, options: NSJSONWritingOptions.PrettyPrinted)
//            return data
//
//        } catch let error as NSError {
//            print("user pasre error \(error)")
//            return nil
//        }
        return dataDict
    }

    enum BirdKey:String {
        case Id = "_id"
        case Image = "image"
        case ScientificName = "scientificname"
        case CommonName = "commonname"
        case Location = "location"
        case Date = "date"
        case Weather = "weather"
        case Status = "status"
        case Votes = "votes"
        case SeenByUser = "seenbyuser"
        case Owner = "owner"
        case Comments = "comments"
    }


}

class User:NSObject {
    var userId:String! = ""
    var userName:String! = ""
    var fullName:String! = ""
    var email:String! = ""
    var password:String! = ""

    override init() {
        super.init()
    }

    init(dataDictionary:NSDictionary) {
        super.init()
        self.userId = dataDictionary[UserKey.Id.rawValue] as? String ?? ""
        self.userName = dataDictionary[UserKey.UserName.rawValue] as? String ?? ""
        self.fullName = dataDictionary[UserKey.FullName.rawValue] as? String ?? ""
        self.email = dataDictionary[UserKey.Email.rawValue] as? String ?? ""
        self.password = dataDictionary[UserKey.Password.rawValue] as? String ?? ""
    }

    func uploadData()-> AnyObject? {
        let dataDict = [UserKey.UserName.rawValue : self.userName,
                        UserKey.FullName.rawValue : self.fullName,
                        UserKey.Email.rawValue : self.email,
                        UserKey.Password.rawValue : self.password]

//        do {
//        let data = try NSJSONSerialization.dataWithJSONObject(dataDict, options: NSJSONWritingOptions.PrettyPrinted)
//            return data
//
//        } catch let error as NSError {
//            print("user pasre error \(error)")
//            return nil
//        }
        return dataDict
    }

    enum UserKey:String {
        case Id = "_id"
        case UserName = "username"
        case FullName = "fullname"
        case Email = "email"
        case Password = "password"
    }
}

extension NSMutableData {

    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}