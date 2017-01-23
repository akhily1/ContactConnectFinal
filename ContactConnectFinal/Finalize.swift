//
//  Finalize.swift
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/9/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

import UIKit

class Finalize: UIViewController {
    
    // MARK: IBOutlet Properties
    
 
    var number:String = ""
    var category:String = ""
    var data: String = ""
    var fbtext:String = ""
    var twtext:String = ""
    var soundcloudtext:String = ""
    var gtext:String = ""
    var fourtext:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        [self.submit()];
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     func submit() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://techsoftwiki.com/techsoftwiki.com/webservice/insertshare.php")!)
        request.HTTPMethod = "POST"
        let postString = "phone_number=\(number)&category=\(category)&facebook=\(fbtext)&twitter=\(twtext)&linkedin=\(data)&soundcloud=\(soundcloudtext)&gmail=\(gtext)&foursquare=\(fourtext)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            print("response = \(response)")
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        }
        task.resume()
        self.performSegueWithIdentifier("back", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "back") {
            
            let secondVC: MasterViewController = segue.destinationViewController as! MasterViewController
            secondVC.number = self.number
            secondVC.fbid = self.fbtext
            
        }

        
    }
    
}