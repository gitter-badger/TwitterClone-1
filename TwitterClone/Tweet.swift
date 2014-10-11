//
//  Tweet.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/6/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation
import UIKit

class Tweet
{
    var text : String?
    var name : String?
    var avatarURL : NSURL?
    var handle : String?
    var timeStamp : String?
    var id : Int
    var biggerAvatarURL : NSURL?
    var networkController = NetworkController()
    
    init (tweetInfo : NSDictionary)
    {
        //get tweet
        self.text = tweetInfo["text"] as? String
        
        //get get user info
        let userInfo = tweetInfo["user"] as NSDictionary
        
        //get name
        self.name = userInfo["name"] as? String
        
        //get handle
        var screenName = userInfo["screen_name"] as String
        self.handle = "@" + screenName
        
        //get timestamp
        let formatter = NSDateFormatter()
        formatter.dateFormat = "E MMM dd HH:mm:ssZ yyyy"
        let date = formatter.dateFromString(tweetInfo["created_at"] as String)!
        formatter.dateFormat = "h:mm a"
        self.timeStamp = formatter.stringFromDate(date)
        
        //set id
        self.id = tweetInfo["id"] as Int
        
        //set url for avatar
        let avatarURLString = userInfo["profile_image_url"] as String
        self.avatarURL = NSURL(string: avatarURLString)
        
        //set url for bigger avatr
        let biggerAvatarURLString = avatarURLString.stringByReplacingOccurrencesOfString("_normal", withString: "_bigger", options: nil, range: nil)
        self.biggerAvatarURL = NSURL(string: biggerAvatarURLString)
        
    }
    
    class func parseJSONDataIntoTweets(rawJSONData: NSData) -> [Tweet]?
    {
        var error : NSError?
        if let JSONArray = NSJSONSerialization.JSONObjectWithData(rawJSONData, options: nil, error: &error) as? NSArray
        {
            var tweets = [Tweet]()
            
            for JSONDictionary in JSONArray
            {
                if let tweetDictionary = JSONDictionary as? NSDictionary
                {
                    var newTweet = Tweet(tweetInfo: tweetDictionary)
                    tweets.append(newTweet)
                }
            }
            
            return tweets
        }
        
        return nil
    }
}