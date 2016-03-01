//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by Kolton on 2/28/16.
//  Copyright © 2016 Kolton. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    
    @IBOutlet weak var TableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TableView.dataSource = self
        TableView.delegate = self
        
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.TableView.reloadData()
            }) { (error: NSError) -> () in
                print(error.localizedDescription)
        }
        
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    @IBAction func onLogoutButton(sender: AnyObject) { TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onRtButton(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetViewCell
        print(cell.tweetID)
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/statuses/retweet/\(cell.tweetID).json", parameters: nil, success: nil, failure: nil)
    }
    
    @IBAction func onFavButton(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetViewCell
        print(cell.tweetID)
        TwitterClient.sharedInstance.POST("https://api.twitter.com/1.1/favorites/create.json?id=\(cell.tweetID)", parameters: nil, success: nil, failure: nil)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if let tweets = tweets{
             print("found tweets")
            return tweets.count
        } else {
            print(" no tweets found ")
            return 0
        }
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetViewCell", forIndexPath: indexPath) as! TweetViewCell
        cell.tweetLabel.text = tweets[indexPath.row].text as! String
        cell.usernameLabel.text = tweets[indexPath.row].username as! String
        cell.profileImage.setImageWithURL(tweets[indexPath.row].userProfileImage!)
        cell.tweetID = tweets[indexPath.row].tweetID
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .ShortStyle
        let timestamp = tweets[indexPath.row].timestamp
        cell.timestampLabel.text = formatter.stringFromDate(timestamp!)
        cell.numberFavs.text = String(tweets[indexPath.row].favortitesCount)
        cell.numberRTs.text = String(tweets[indexPath.row].retweetCount)
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
