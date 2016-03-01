//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Kolton on 2/28/16.
//  Copyright © 2016 Kolton. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSDate?
    var username: NSString?
    var userProfileImage: NSURL?
    var retweetCount: Int = 0;
    var favortitesCount: Int = 0;
    var tweetID: Int = 0;
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favortitesCount = (dictionary["favorite_count"] as? Int) ?? 0
        //print(favortitesCount)
        tweetID = (dictionary["id"] as? Int) ?? 0
        //print(tweetID)
        let user = dictionary["user"]
        username = user!["name"] as? String
        
        let profileUrlString = user!["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString{
            userProfileImage = NSURL(string: profileUrlString)
        }
        
        //print(profileUrlString)

        let timestampString = dictionary["created_at"] as? String
        //print(timestampString)
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
            //print(timestamp)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
