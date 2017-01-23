//
//  FacebookCo.swift
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/22/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

import UIKit

class FacebookCo: UIViewController {
    
    // MARK: IBOutlet Properties
    var number:String = ""
    var fbtext:String = ""
    
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
        let request = NSMutableURLRequest(URL: NSURL(string: "http://techsoftwiki.com/techsoftwiki.com/webservice/insertfb.php")!)
        request.HTTPMethod = "POST"
        let postString = "number=\(number)&facebook=\(fbtext)"
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