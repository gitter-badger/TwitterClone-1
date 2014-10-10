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

class HomeTimeLineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //MARK: Properties and outlets
    
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var tweetSortStyle: String = "default"
    var networkController = NetworkController()
    var lastIndexPath : NSIndexPath?
    var refreshControl:UIRefreshControl!
    let homeTimeLineURLString = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    var sinceIdUrlString : String?
    
    //MARK: View methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.networkController.fetchTimeLine (self.homeTimeLineURLString)
        { (errorDescription, tweets) -> (Void) in
            if errorDescription != nil
            {
                //error message
            }
            else
            {
                self.tweets = tweets
                self.tableView.reloadData()
            }
        }
        
        //auto row size
        //self.tableView.rowHeight = UITableViewAutomaticDimension
        //self.tableView.estimatedRowHeight = 80.0
        
        //pull to refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        let sortButton = UIBarButtonItem(title: "Sort", style: UIBarButtonItemStyle.Plain, target: self, action: "sortTweets")
        self.navigationItem.leftBarButtonItem = sortButton
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        if let indexPath = lastIndexPath
        {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        }
    }
    
    //MARK: TableVIew Methods
      
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        var tweet = self.tweets?[indexPath.row]
//        cell.tweetText.
        
        //sets twitter handle for tweet
        cell.tweetName.text = tweet?.name
        
        //sets avatar image for tweet
        if tweet?.avatar != nil
        {
            cell.tweetAvatar.image = tweet?.avatar
        }
        else
        {
            self.networkController.downloadUserImageForTweet(tweet!, completionHandler:
            { (image) -> (Void) in
                let cellForImage = self.tableView.cellForRowAtIndexPath(indexPath) as TweetCell?
                cellForImage?.tweetAvatar.image = image
            })
        }
        
        //sets image properties (round, has a boarder, clips to container). A lot of it is superfluous.
        cell.tweetAvatar.layer.cornerRadius = cell.tweetAvatar.frame.size.width / 2
        cell.tweetAvatar.layer.masksToBounds = true
        cell.tweetAvatar.layer.borderWidth = 0.5
        cell.tweetAvatar.clipsToBounds = true
        cell.tweetAvatar.contentMode = UIViewContentMode.ScaleAspectFill
        cell.tweetAvatar.setNeedsDisplay()
        
        cell.tweetTime.text = tweet?.timeStamp
        
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
        
        cell.tweetText?.text = tweet?.text
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let tweet = self.tweets?[indexPath.row]
        self.lastIndexPath = indexPath
        let destinationVC = self.storyboard?.instantiateViewControllerWithIdentifier("SINGLE_TWEET_VC") as SingleTweetViewController
        destinationVC.singleTweet = tweet
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    //MARK: Other stuff
    
    func refresh(sender: AnyObject!)
    {
        println("HERE I IS")
        var lastTweet : Tweet = self.tweets![0]
        var lastTweetID : String = lastTweet.id.description
        self.sinceIdUrlString = homeTimeLineURLString + "?since_id=" + lastTweetID
        self.networkController.fetchTimeLine(sinceIdUrlString!, completionHandler:
        { (errorDescription, tweets) -> (Void) in
            println("HERE I IS")
            if let newTweets = tweets {
                self.tweets = tweets! + self.tweets!
                self.tableView.reloadData()
            }
            self.refreshControl.endRefreshing()
        })
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
