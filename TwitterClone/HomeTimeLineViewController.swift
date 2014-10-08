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
    @IBOutlet weak var tableView: UITableView!
    var tweets : [Tweet]?
    var tweetSortStyle: String = "default"
    var networkController = NetworkController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       self.networkController.fetchHomeTimeLine
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
    
    //MARK: TableVIew Methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("TWEET_CELL", forIndexPath: indexPath) as TweetCell
        var tweet = self.tweets?[indexPath.row]
//        cell.tweetText.
        
        //sets twitter handle for tweet
        cell.tweetHandle.text = tweet?.handle
        
        //sets avatar image for tweet
        cell.tweetAvatar.image = tweet?.avatar
        
        //sets image properties (round, has a boarder, clips to container). A lot of it is superfluous.
        cell.tweetAvatar.layer.cornerRadius = cell.tweetAvatar.frame.size.width / 2
        cell.tweetAvatar.layer.masksToBounds = true
        cell.tweetAvatar.layer.borderWidth = 0.5
        cell.tweetAvatar.clipsToBounds = true
        cell.tweetAvatar.contentMode = UIViewContentMode.ScaleAspectFill
        cell.tweetAvatar.setNeedsDisplay()
        
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
