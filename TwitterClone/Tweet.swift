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
    var avatar : UIImage?
    var handle : String?
    
    init (tweetInfo : NSDictionary)
    {
        //get tweet
        self.text = tweetInfo["text"] as? String
        //get avatar
        let userInfo = tweetInfo["user"] as NSDictionary
        let avatarURLString = userInfo["profile_image_url"] as String
        let avatarURL = NSURL(string: avatarURLString)
        let avatarData = NSData(contentsOfURL: avatarURL)
        self.avatar = UIImage(data: avatarData)
        //get handle
        self.handle = userInfo["name"] as? String
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