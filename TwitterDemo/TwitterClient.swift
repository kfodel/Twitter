//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Kolton on 2/28/16.
//  Copyright © 2016 Kolton. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "BMwKNbB0RZZVmKLzbcRbGa5wo", consumerSecret: "TnGauwcbc465tR5ewqVUXcPXHofwD39vvL78BScBnMLNRrm1wn")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError)->())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        let client = TwitterClient.sharedInstance
        client.deauthorize()
        client.fetchRequestTokenWithPath("/oauth/request_token", method: "GET", callbackURL: NSURL(string:"twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
        
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("/oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            
            }) { (error: NSError!) -> Void in
                print("error \(error.localizedDescription)")
                self.loginFailure?(error)
        }

    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        print("here")
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            print(dictionaries)
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
           
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    }
    
    func currentAccount(success: (User)->(), failure: (NSError)->()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //print("account: \(response)")
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
    
}
