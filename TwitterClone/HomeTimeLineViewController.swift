//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/6/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit
import Accounts
import Social

class HomeTimeLineViewController: UIViewController, UITableViewDataSource
{
    var tweets : [Tweet]?
    var tweetSortStyle: String = "default"
    var twitterAccount : ACAccount?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil)
            { (granted: Bool, error : NSError!) -> Void in
                if granted
                {
                    let accounts = accountStore.accountsWithAccountType(accountType)
                    self.twitterAccount = accounts.first as ACAccount?
                    //setup our twitter request
                    let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                    let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                    twitterRequest.account = self.twitterAccount
                    
                    twitterRequest.performRequestWithHandler(
                    { (data, httpResponse, error) -> Void in
                        
                        switch httpResponse.statusCode
                        {
                            case 200...299:
                                println("this is good!")
                                self.tweets = Tweet.parseJSONDataIntoTweets(data)
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    self.tableView.reloadData()
                                })
                                //At this point we are in a background thread. Left main thread at "performRequestWithHandler."
                            case 400...499:
                                println("This is the client's fault.")
                            case 500...5999:
                                println("This is the server's fault.")
                            default:
                                println("something bad happened")
                        }
                        
                    })
                }
            }
        
        if let path = NSBundle.mainBundle().pathForResource("tweet", ofType: "json")
        {
            var error : NSError?
            let jsonData = NSData(contentsOfFile: path)
            
            self.tweets = Tweet.parseJSONDataIntoTweets(jsonData)
        }
        
        let sortButton = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.Plain, target: self, action: "sortTweets")
        self.navigationItem.leftBarButtonItem = sortButton
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.tweets != nil
        {
            return self.tweets!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as UITableViewCell
        var tweet = self.tweets?[indexPath.row]
        
        switch tweetSortStyle
        {
//            case "chronological":
//                let tweet = self.tweets?[indexPath.row]
//            
            case "alphabetical":
                tweets!.sort{$0.text < $1.text}
                tweet = self.tweets?[indexPath.row]
            
            default:
                println("default layout")
            
        }
        
        cell.textLabel?.text = tweet?.text

        return cell
    }
    
    func sortTweets ()
    {
        tweetSortStyle = "alphabetical"
        self.tableView.reloadData()
    }
    
    //MARK: No idea why this thing exists but afraid to delete it.

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
