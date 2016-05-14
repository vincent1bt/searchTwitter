//
//  Data.swift
//  twitterSearch
//
//  Created by vicente rodriguez on 2/25/16.
//  Copyright © 2016 vicente rodriguez. All rights reserved.
//

import Foundation
import TwitterKit

typealias Response = (JSON?, NSError?) -> Void


struct Data {
    static let sharedData = Data()
    
    func getUser(userName: String, onCompletion: Response) {
        //endPoint
        let usersLookupEndPoint = "https://api.twitter.com/1.1/users/lookup.json"
        //parametros requeridos
        let params = ["screen_name": userName]
        makeRequest(params, endPoint: usersLookupEndPoint) {
            json, error in
            onCompletion(json, error)
        }
        
    }
    
    func getTweets(userID: Int, onCompletion: Response) {
        //endPoint
        let usersLookupEndPoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        //parametros requeridos
        let params = [
            "user_id": "\(userID)",
            "count": "100",
            "include_rts": "false",
            "exclude_replies": "true",
            "trim_user": "true"
        ]
        
        makeRequest(params, endPoint: usersLookupEndPoint) {
            json, error in
            onCompletion(json, error)
        }
        
    }
    
    func makeRequest(params: [String: String], endPoint: String, onCompletion: Response) {
        if let userID = Twitter.sharedInstance().sessionStore.session()?.userID {
            //usa el cliente que inicio sesion en twitter
            let client = TWTRAPIClient(userID: userID)
            
            var clientError: NSError?
            var json: JSON?
            
            //se hace la peticion a twitter
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: endPoint, parameters: params, error: &clientError)
            
            //si no hay error se obtienen los datos
            if clientError == nil {
                client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
                    
                    if connectionError == nil {
                        json = JSON(data: data!)
                        onCompletion(json, clientError)
                    }
                    else
                    {
                        onCompletion(json, connectionError)
                    }
                }
            }
            else
            {
                onCompletion(json, clientError)
            }
        }
    }
    
}