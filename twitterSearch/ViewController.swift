//
//  ViewController.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 2/25/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID: String? = Twitter.sharedInstance().sessionStore.session()?.userID
        
        if userID == nil{
            addLoginButton()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let _: String? = Twitter.sharedInstance().sessionStore.session()?.userID {
            performSegueWithIdentifier("getMap", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addLoginButton() {
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if session != nil {
                //print("signed as \(session!.userName)")
                self.performSegueWithIdentifier("getMap", sender: nil)
            
            } else {
                let ac = UIAlertController(title: "No se pudo iniciar sesion", message: "\(error!.localizedDescription)", preferredStyle: .Alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(ac, animated: true, completion: nil)
            }
            
        })
        
        logInButton.center = self.view.center
        logInButton.center.y = self.view.frame.height - logInButton.frame.height
        
        self.view.addSubview(logInButton)
    }

}

