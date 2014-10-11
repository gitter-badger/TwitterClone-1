//
//  NetworkController.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/8/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import Foundation
import Accounts
import Social

class NetworkController
{

    let accountStore = ACAccountStore()
    var twitterAccount : ACAccount?
    let imageQueue = NSOperationQueue()
    var imageCache = [String:[UIImage]]() // [Username:[small,big]]
    
    init ()
    {
        self.imageQueue.maxConcurrentOperationCount = 10
    }
    
    //Makes NetworkController a singleton
    class var sharedInstance: NetworkController
    {
        struct Static
        {
            static let instance = NetworkController()
        }
        return Static.instance
    }
    
    func fetchTimeLine(targetURL: String, completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        
        let accountStore = self.accountStore
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted
            {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                
                //twitter request
                let url = NSURL(string: targetURL)
                let twitterRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: SLRequestMethod.GET, URL: url, parameters: nil)
                twitterRequest.account = self.twitterAccount
                
                twitterRequest.performRequestWithHandler(
                    { (data, httpResponse, error) -> Void in
                    
                        switch httpResponse.statusCode
                        {
                            case 200...299:
                                let tweets = Tweet.parseJSONDataIntoTweets(data)
                                println(tweets?.count)
                                NSOperationQueue.mainQueue().addOperationWithBlock(
                                { () -> Void in
                                    completionHandler(errorDescription: nil, tweets: tweets)
                                })
                                //At this point we're in a background thread. We left main thread at "performRequestWithHandler."
                            case 400...499:
                                println("this is the clients fault")
                                println(httpResponse.description)
                                completionHandler(errorDescription: "This is your fault", tweets: nil)
                            case 500...599:
                                println("this is the servers fault")
                                completionHandler(errorDescription: "Our servers are currently down", tweets: nil)
                            default:
                                println("something bad happened")
                        }
                    
                    })
            }
        }
        
    }
    
    func downloadUserImageForTweet(tweet : Tweet, completionHandler : (image : UIImage) -> (Void))
    {
        self.imageQueue.addOperationWithBlock
            { () -> Void in
                let imageData = NSData(contentsOfURL: tweet.avatarURL!)
                let avatarImage = UIImage(data: imageData)
                let handle = tweet.handle as String!
                var imageArray = self.imageCache[handle] as [UIImage]!
                
                if (self.imageCache[handle] == nil)
                {
                    self.imageCache[handle] = [avatarImage] //maybe put the image download code here so you can put the bigger image download in the else?
                }
                else
                {
                    imageArray.append(avatarImage)
                }
                
            NSOperationQueue.mainQueue().addOperationWithBlock(
                { () -> Void in
                    completionHandler(image: avatarImage)
                })
            }
    }

}
