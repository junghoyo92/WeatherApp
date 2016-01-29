//
//  ViewController.swift
//  Weather
//
//  Created by Hoyoung Jung on 1/23/16.
//  Copyright © 2016 Hoyoung Jung. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func Search(sender: AnyObject) {
        
        var wasSuccessful = false
        
        //converts the url string as an NSURL and checks for spaced city names
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + nameTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        //checks to see if invalid characters are entered
        if let url = attemptedUrl {
        
        // This method extracts the code and from a website and allows one to utilize the pre-existing code
        // NSURLSession is like opening a browser tab virtually through the URL
        // dataTaskWithURL opens the url string that is created before and stores data, response and an error if there is one
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
            
            // Code Will occur when task completes
            
            // This checks to see if the data is returned or not and keeps the program from crashing
            if let urlContent = data {
                
                //Take our url content and convert it to the correct encoding
                
                //create an nsstring from urlContent which is already unwrapped by encoding NSUTF8StringEncoding, which is standard encoding
                let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                
                let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                
                if websiteArray.count > 1 {
                    
                    let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                    
                    if weatherArray.count > 1 {
                        
                        wasSuccessful = true
                        
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        print(weatherSummary)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.resultLabel.text = weatherSummary
                        })
                    }
                }
                
            }
            
            if wasSuccessful == false {
                self.resultLabel.text = "Please enter a valid city name."
            }
            
        }
        task.resume()
        
        } else {
            self.resultLabel.text = "Please enter a valid city name."
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Closes the keyboard by pressing anywhere
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    // Closes the keyboard by pressing return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}

