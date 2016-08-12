//
//  AppUtils.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 5/31/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class AppUtils: NSObject {
    
    class func showAlert(owner owner:UIViewController!, title:String?, message:String, actions:[UIAlertAction]?) {
        
        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        var activeActions = [closeAction]
        
        if actions != nil {
            activeActions = actions!
        }
        
        AppUtils.showCredentialAlert(owner: owner, title: title, message: message, inputFields: nil, actions: activeActions)
    }
    
    class func showCredentialAlert(owner owner:UIViewController!,title:String?, message:String, inputFields:[UITextField]?, actions:[UIAlertAction]) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message:  message, preferredStyle: UIAlertControllerStyle.Alert)
        
        if let textFields = inputFields {
            for var field in textFields {
                alert.addTextFieldWithConfigurationHandler({ (textField) in
                    textField.placeholder = field.placeholder
                    textField.text = field.text
                    textField.textColor = field.textColor
                    textField.textAlignment = field.textAlignment
                    textField.secureTextEntry = field.secureTextEntry
                    field = textField
                })
            }
        }
        
        
        for action in actions {
            alert.addAction(action)
        }

        dispatch_async(dispatch_get_main_queue(), {
            
            owner.presentViewController(alert, animated: true, completion: {
            })
            
        })
        
        return alert
        
    }
    
    class func updateNavBar(navBar:UINavigationBar, withImage:UIImage) {
        
        let bg = AppUtils.resizeImage(withImage, toSize: CGSize(width: navBar.bounds.size.width, height: navBar.bounds.size.height+20))
        
        navBar.setBackgroundImage(bg, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = AppUtils.resizeImage(withImage, toSize: CGSize(width: navBar.bounds.size.width, height: 1))
    }

    class func loadImage(imageUrl:String, callback:((image:UIImage?)->())) {
        if (imageUrl.isEmpty) {
            callback(image:nil)
            return
        }

        let imageName = NSURL(string:imageUrl)?.lastPathComponent

        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let filePath = paths.first?.stringByAppendingString(imageName!)


        if NSFileManager.defaultManager().fileExistsAtPath(filePath!) && NSData(contentsOfFile: filePath!)?.length > 0 {
            callback(image: UIImage(contentsOfFile: filePath!))
        } else {
            let urlStr = "\(baseUrl)/\(imageUrl)"
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlStr)!, completionHandler: { (data, resp, error) in
                if error == nil && (resp as! NSHTTPURLResponse).statusCode == 200{
                    do {
                        try data?.writeToFile(filePath!, options: NSDataWritingOptions.AtomicWrite)
                    } catch let saveError {
                        print("image save err \(saveError)")
                    }
                    callback(image: UIImage(data: data!))
                } else {

                }
            }).resume()
        }
    }

    class func loadImage(imageUrl:String, toImageView imageView:UIImageView) {
        if (imageUrl.isEmpty) {
            imageView.image = nil
            return
        }

        let imageName = NSURL(string:imageUrl)?.lastPathComponent

        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let filePath = paths.first?.stringByAppendingString(imageName!)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {

            if NSFileManager.defaultManager().fileExistsAtPath(filePath!) && NSData(contentsOfFile: filePath!)?.length > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    imageView.image = UIImage(contentsOfFile: filePath!)
                })
            } else {

                let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
                spinner.color = UIColor.darkGrayColor()
                spinner.hidesWhenStopped = true
                imageView.addSubview(spinner)
                spinner.center = CGPoint(x: imageView.bounds.width/2, y: imageView.bounds.height/2)
                spinner.stopAnimating()


                let urlStr = "\(baseUrl)/\(imageUrl)"
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlStr)!, completionHandler: { (data, resp, error) in
                    if error == nil && (resp as! NSHTTPURLResponse).statusCode == 200{
                        do {
                            try data?.writeToFile(filePath!, options: NSDataWritingOptions.AtomicWrite)
                        } catch let saveError {
                            print("image save err \(saveError)")
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            spinner.removeFromSuperview()
                            imageView.image = UIImage(data: data!)
                        })
                    } else {
                        spinner.removeFromSuperview()
                        imageView.image = nil
                    }
                }).resume()
            }
        })

    }

    private class func resizeImage(image:UIImage, toSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0);
        image.drawInRect(CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    
    class func rgb(r r:Float,g:Float,b:Float) -> UIColor {
        return UIColor.init(colorLiteralRed:r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    class func rgba(r r:Float,g:Float,b:Float,a:Float) -> UIColor {
        return UIColor.init(colorLiteralRed:r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    
    class func rgb_hex(rgbValue:Int) -> UIColor {
        return UIColor.init(colorLiteralRed:((Float)((rgbValue & 0xFF0000) >> 16))/255.0,
                            green: ((Float)((rgbValue & 0x00FF00) >>  8))/255.0,
                            blue: ((Float)((rgbValue & 0x0000FF) >>  0))/255.0,
                            alpha: 1.0)
    }
}

func stringToBool(string:String?) -> Bool {
    var res = false
    if string?.lowercaseString == "true" || string == "1" || string?.lowercaseString == "yes" {
        res = true
    }
    return res
}

func boolToString(bol:Bool) -> String {
    var res = "false"
    if bol { res = "true" }
    return res
}
