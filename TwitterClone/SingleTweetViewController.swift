//
//  TweetViewController.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/8/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class SingleTweetViewController: UIViewController
{
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var singleTweet : Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avatarImageView.image = singleTweet?.avatar
        self.twitterNameLabel.text = singleTweet?.name
        self.twitterHandleLabel.text = singleTweet?.handle
        self.tweetBodyLabel.text = singleTweet?.text
        self.timeStampLabel.text = singleTweet?.timeStamp

        //let normalRange = avatarString?.rangeOfString("_normal", options: nil, range: nil, locale: nil)
        //let newString = avatarString?.stringByReplacingCharactersInRange(normalRange!, withString: "_bigger")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
