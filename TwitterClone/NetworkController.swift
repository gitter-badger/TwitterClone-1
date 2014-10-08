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
    
    init ()
    {
    }
    
    func fetchHomeTimeLine(completionHandler : (errorDescription : String?, tweets : [Tweet]?) -> (Void)) {
        
        let accountStore = self.accountStore
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted : Bool, error : NSError!) -> Void in
            if granted
            {
                let accounts = accountStore.accountsWithAccountType(accountType)
                self.twitterAccount = accounts.first as ACAccount?
                
                //twitter request
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
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
    
}
