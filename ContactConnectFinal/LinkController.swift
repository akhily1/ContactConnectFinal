//
//  LinkedController.swift
//  Contact
//
//  Created by Akhil Yeleswar on 5/22/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

import UIKit

class LinkController: UIViewController, UIWebViewDelegate {
    
    // MARK: IBOutlet Properties
    
    
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Constants
    
    let linkedInKey = "75kj85t8epm42o"
    
    let linkedInSecret = "bhd8leuIgP9M0KF4"
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    var fourtext:String = "";
    var number:String = "";
    var category:String = "";
    var fbtext:String = "";
    var twtext:String = "";
    var soundcloudtext:String = "";
    var gtext:String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        webView.delegate = self
        
        startAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: IBAction Function
    
    
    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Custom Functions
    
    func startAuthorization() {
        // Specify the response type which should always be "code".
        let responseType = "code"
        
        // Set the redirect URL. Adding the percent escape characthers is necessary.
        let redirectURL = "https://www.linkedin.com".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
        
        // Create a random string based on the time intervale (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        // Set preferred scope.
        let scope = "r_basicprofile"
        
        
        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        
        
        // Create a URL request and load it in the web view.
        let request = NSURLRequest(URL: NSURL(string: authorizationURL)!)
       webView.loadRequest(request)
    }
    
    
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://www.linkedin.com".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.alphanumericCharacterSet())!
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        // Convert the POST parameters into a NSData object.
        let postData = postParams.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(URL: NSURL(string: accessTokenEndPoint)!)
        
        // Indicate that we're about to make a POST request.
        request.HTTPMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.HTTPBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        
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
                    
                    let accessToken = dataDictionary["access_token"] as! String
                    
                    NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "LIAccessToken")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.performSegueWithIdentifier("showBacksoff", sender: self)
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        
        task.resume()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showBacksoff") {
            let secondVC: ChooseViewController = segue.destinationViewController as! ChooseViewController
            secondVC.check = "yes"
            secondVC.fourtext = self.fourtext
            secondVC.number = self.number
            secondVC.category = self.category
            secondVC.fbtext = self.fbtext;
            secondVC.twtext = self.twtext;
            secondVC.gtext = self.gtext;
            secondVC.soundcloudtext = self.soundcloudtext;
        }

    }
    // MARK: UIWebViewDelegate Functions
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!
        print(url)
        
        if url.host == "www.linkedin.com" {
            if url.absoluteString.rangeOfString("code") != nil {
                // Extract the authorization code.
                let urlParts = url.absoluteString.componentsSeparatedByString("?")
                let code = urlParts[1].componentsSeparatedByString("=")[1]
                
                requestForAccessToken(code)
            }
        }
        return true
    }
}