//
//  ArrCounts.swift
//  ContactConnectFinal
//
//  Created by Akhil Yeleswar on 7/24/16.
//  Copyright © 2016 Akhil Yeleswar. All rights reserved.
//

class ArrCounts: UIViewController {
    
    // MARK: IBOutlet Properties
    var fbid:String = ""
    var number:String = ""
    var yournumber:String = ""
    var first:String = ""
    var last:String = ""
    var othernumber:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.setHidesBackButton(true, animated:true);
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
        let request = NSMutableURLRequest(URL: NSURL(string: "http://techsoftwiki.com/techsoftwiki.com/webservice/insertcells.php")!)
        request.HTTPMethod = "POST"
        let postString = "yournumber=\(yournumber)&first=\(first)&last=\(last)&otherphone=\(othernumber)"
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
            secondVC.fbid = self.fbid
            
        }
        
        
    }
    
}