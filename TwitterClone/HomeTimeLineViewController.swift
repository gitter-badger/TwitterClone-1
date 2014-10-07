//
//  HomeTimeLineViewController.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/6/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class HomeTimeLineViewController: UIViewController, UITableViewDataSource
{
    var tweets : [Tweet]?
    var tweetSortStyle: String = "default"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
                println("default laout")
            
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
