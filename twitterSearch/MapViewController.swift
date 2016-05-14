//
//  MapViewController.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 2/25/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import UIKit
import TwitterKit
import MapKit

class MapViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowBottomConstraint: NSLayoutConstraint!
    
    var logOutHidden: Bool = true
    let client = TWTRAPIClient()
    let clientData = Data.sharedData
    var locations = [Location]()

    var exitGestor: UISwipeGestureRecognizer!
    var hiddenGestor: UISwipeGestureRecognizer!
    var logOutGestor: UITapGestureRecognizer!
    
    @IBOutlet weak var arrowLabel: UILabel!
    @IBOutlet weak var textFieldLabel: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var localizarButton: UIButton!
    
    var exitView: UIView!
    var viewShadow: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldLabel.delegate = self
        configureExtraViews()
        configureGestures()
    }
    
    func configureExtraViews() {
        let viewFrame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
        exitView = UIView(frame: viewFrame)
        exitView.backgroundColor = UIColor.init(red: 192/255, green: 57/255, blue: 43/255, alpha: 1.0)
        let exitLabel = UILabel()
        exitLabel.text = "Salir"
        exitLabel.textAlignment = .Center
        exitLabel.textColor = UIColor.whiteColor()
        exitLabel.frame = CGRect(x: 0, y: 0, width: self.exitView.frame.width, height: 55)
        exitView.addSubview(exitLabel)
        self.view.addSubview(exitView)
        
        let viewShadowFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        viewShadow = UIView(frame: viewShadowFrame)
        viewShadow.backgroundColor = UIColor.blackColor()
        viewShadow.alpha = 0.5
        self.view.addSubview(self.viewShadow)
    }
    
    func configureGestures() {
        self.exitGestor = UISwipeGestureRecognizer(target: self, action: #selector(self.showExit))
        exitGestor.direction = .Up
        self.view.addGestureRecognizer(exitGestor)
        
        self.hiddenGestor = UISwipeGestureRecognizer(target: self, action: #selector(self.hideExit))
        hiddenGestor.direction = .Down
        self.view.addGestureRecognizer(hiddenGestor)
        
        self.logOutGestor = UITapGestureRecognizer(target: self, action: #selector(self.logOutFromTwitter))
        self.exitView.addGestureRecognizer(self.logOutGestor)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let userID: String? = Twitter.sharedInstance().sessionStore.session()?.userID
        
        if  (userID == nil) {
            if let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginController") as? ViewController {
                self.presentViewController(loginController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "getMapInfo" {
            let controller = segue.destinationViewController as! InfoMapViewController
            controller.locations = self.locations
        }
    }
    
    func showError(title: String, error: String) {
        let ac = UIAlertController(title: title, message: error , preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let userName = self.textFieldLabel.text
        if userName == "" {
            self.showError("Ingresa un nombre de usuario", error: "No puede estar vacio")
            return false
        }
        printData(userName!)
        return true
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        self.textFieldLabel.resignFirstResponder()
    }
    
    func logOutFromTwitter() {
        let store = Twitter.sharedInstance().sessionStore
            
        if let userID = store.session()!.userID {
            store.logOutUserID(userID)
            performSegueWithIdentifier("logIn", sender: self)
        }
        
    }
    
    @IBAction func textFieldDoneEditing(sender:  UITextField) {
        self.textFieldLabel.resignFirstResponder()
    }
    
    @IBAction func search(sender: AnyObject) {
        let userId = User.newUser.id
        clientData.getTweets(userId, onCompletion: { json, error in
            if let newError = error {
                self.showError("Error al cargar los tweets", error: newError.localizedDescription)
                return
            }
            
            for key in json! {
                let geo: NSArray? = key.1["geo"]["coordinates"].object as? NSArray
                if let geoObject = geo {
                    let newLocation = Location(coordinate: CLLocationCoordinate2D(latitude: geoObject[0] as! Double, longitude: geoObject[1] as! Double))
                    self.locations.append(newLocation)
                }
            }
            self.performSegueWithIdentifier("getMapInfo", sender: self)
        })
    }
    
    func showExit() {
        guard logOutHidden else {
            return
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.arrowBottomConstraint.constant += 55
            self.arrowLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            
            self.labelTopConstraint.constant -= 40
            self.exitView.frame = CGRect(x: 0, y: self.view.frame.height - 55, width: self.view.frame.width, height: 55)
            self.view.layoutIfNeeded()
            
            }, completion: { (finished) -> Void in
                self.viewShadow.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 55)
                self.logOutHidden = false
        })
    }
    
    func hideExit() {
        guard !logOutHidden else {
         return
        }
        self.viewShadow.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.arrowBottomConstraint.constant -= 55
            self.arrowLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
            
            self.labelTopConstraint.constant += 40
            self.exitView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 0)
            self.view.layoutIfNeeded()
            
            }, completion: { (finished) -> Void in
                self.logOutHidden = true
        })
    }
    
    func printData(userName: String) {
        clientData.getUser(userName, onCompletion: { [unowned self] (json, error)  in
            if let newError = error {
                self.showError("Error Al Buscar Usuario", error: newError.localizedDescription)
                return
            }
            
            let json = json!
            let geo = json[0]["geo_enabled"].object as! Bool
            
            if geo {
                let id = json[0]["id"].object as! Int
                print(id)
                let name = json[0]["name"].object as? String
                let image = json[0]["profile_image_url_https"].object as? String
                
                User.newUser.id = id
                
                let newImage = image?.stringByReplacingOccurrencesOfString("_normal", withString: "")
                let imageUrl = NSURL(string: newImage!)
                let imageData = NSData(contentsOfURL: imageUrl!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.nameLabel.text = name
                    self.localizarButton.hidden = false
                    self.imageView.image = UIImage(data: imageData!)
                }
                
            } else
            {
                self.showError("Error con usuario", error: "Este usuario no tiene habilitada la ubicacion")
            }
            
        })
    }
}
