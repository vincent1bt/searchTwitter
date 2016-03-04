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
    
    let client = TWTRAPIClient()
    
    @IBOutlet weak var textFieldLabel: UITextField!
    let clientData = Data.sharedData
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var localizarButton: UIButton!
    
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textFieldLabel.delegate = self
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
    
    @IBAction func logOut(sender: AnyObject) {
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
