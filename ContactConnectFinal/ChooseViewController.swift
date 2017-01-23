//
//  ChooseViewController.swift
//  Contact
//
//  Created by Akhil Yeleswar on 5/22/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

import UIKit

class ChooseViewController: UIViewController {
    
    // MARK: IBOutlet Properties
    
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    @IBOutlet weak var btnGetProfileInfo: UIButton!
    
    
    @IBOutlet weak var btnOpenProfile: UIButton!
    var receivedlkString: String = ""
    var twtext: String = ""
    var fbtext: String = ""
    var number: String = ""
    var category: String = ""
    var pho: String = ""
    var check: String = ""
    var fourtext:String = ""
    var gtext: String = ""
    var soundcloudtext:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(category)
        print(pho)
        print(receivedlkString)
        print(twtext)
        print(fbtext)
        
        if check == "yes" {
            [self.getProfileInfo()]
        } else {
            self.performSegueWithIdentifier("forward", sender: self)
        }
        
    }
    
    @IBAction func submit(sender: AnyObject) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://techsoftwiki.com/techsoftwiki.com/webservice/insertshare.php")!)
        request.HTTPMethod = "POST"
        let postString = "phone=\(pho)&category=\(category)&facebook=\(receivedlkString)&twitter=\(twtext)&linkedin=\(twtext)"
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        checkForExistingAccessToken()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction Functions
    
    
  func getProfileInfo() {
        if let accessToken = NSUserDefaults.standardUserDefaults().objectForKey("LIAccessToken") {
            // Specify the URL string that we'll get the profile info from.
            
            let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
            
            
            // Initialize a mutable URL request object.
            let request = NSMutableURLRequest(URL: NSURL(string: targetURLString)!)
            
            // Indicate that this is a GET request.
            request.HTTPMethod = "GET"
            
            // Add the access token as an HTTP header field.
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            
            
            // Initialize a NSURLSession object.
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            
            // Make the request.
            let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                // Get the HTTP status code of the request.
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                
                if statusCode == 200 {
                    // Convert the received JSON data into a dictionary.
                    do {
                        let dataDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        let profileURLString = dataDictionary["publicProfileUrl"] as! String
                        
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.receivedlkString = profileURLString
                            NSLog("yaa%@", profileURLString);
                            self.pho = profileURLString
                            NSLog("sawww%@", self.pho);
                            let objCString:NSString = NSString(string:profileURLString);
                            self.performSegueWithIdentifier("showView", sender: self)
                        })
                    }
                    catch {
                        print("Could not convert JSON data into a dictionary.")
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showView") {

            let secondVC: ViewController = segue.destinationViewController as! ViewController
            NSLog("ateee%@", pho);
            NSLog("So%@", self.fourtext);
            secondVC.data = self.pho;
            secondVC.fourtext = self.fourtext;
            secondVC.number = self.number
            secondVC.category = self.category;
            secondVC.fbtext = self.fbtext;
            secondVC.twtext = self.twtext;
            secondVC.gtext = self.gtext;
            secondVC.soundcloudtext = self.soundcloudtext;
            NSLog("sound%@", self.soundcloudtext);
            
        }
        if (segue.identifier == "forward") {
            
            let secondVC: LinkController = segue.destinationViewController as! LinkController
            secondVC.fourtext = self.fourtext;
            secondVC.number = self.number;
            secondVC.category = self.category;
            secondVC.fbtext = self.fbtext;
            secondVC.twtext = self.twtext;
            secondVC.soundcloudtext = self.soundcloudtext;
            secondVC.gtext = self.gtext;
            
        }
        
    }
    
    // MARK: Custom Functions
    
    func checkForExistingAccessToken() {
        if NSUserDefaults.standardUserDefaults().objectForKey("LIAccessToken") != nil {
        }
    }
    
}