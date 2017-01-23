//
//  SubmitCategory.swift
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/10/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

import UIKit

class SubmitCategory: UIViewController {
    
    // MARK: IBOutlet Properties
    
    
    var category:String = ""
    var phone1: String = ""
    var phone2:String = ""
    var name1:String = ""
    var dictContactDetails: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
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
        let request = NSMutableURLRequest(URL: NSURL(string: "http://techsoftwiki.com/techsoftwiki.com/webservice/insertcategory.php")!)
        request.HTTPMethod = "POST"
        let postString = "category=\(category)&recap=\(phone1)&sender=\(phone2)"
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
            
            let secondVC: DetailViewController = segue.destinationViewController as! DetailViewController
            secondVC.number = self.phone2;
            secondVC.name1 = self.name1;
            secondVC.number2 = self.phone1
            secondVC.dictContactDetails = self.dictContactDetails as [NSObject : AnyObject]
        }
        
        
    }
}