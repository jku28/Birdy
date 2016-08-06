//
//  StoryboardManager.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/1/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import UIKit

class StoryboardManager: NSObject {

    class func initiateStoryboard(storyboardName:String) {

        let sb = UIStoryboard(name: storyboardName, bundle: nil)

        if let controller = sb.instantiateInitialViewController() {
            let window = UIApplication.sharedApplication().windows[0]
            window.rootViewController = controller
            window.makeKeyAndVisible()
        }
    }

    class func initialControllerFrom(storyboard storyboardName:String) -> UIViewController? {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let ctrlr = sb.instantiateInitialViewController()
        return ctrlr
    }

    class func controllerFrom(storyboard storyboardName:String, withId:String) -> UIViewController? {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let ctrlr = sb.instantiateViewControllerWithIdentifier(withId)
        return ctrlr
    }
}
