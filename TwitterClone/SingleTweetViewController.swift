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
    // MARK: Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var twitterHandleLabel: UILabel!
    @IBOutlet weak var tweetBodyLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    // MARK: Properties
    var singleTweet : Tweet?
    var networkController = NetworkController()
    
    // MARK: Actions
    @IBAction func avatarTapped(sender: AnyObject)
    {
        
    }
    
    // MARK: - View Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let handle = singleTweet!.handle as String!
        let myCount = self.networkController.imageCache[handle]?.count
        let imageArray = self.networkController.imageCache[handle] as [UIImage]!
        
        if (myCount == 2)
        {
            self.avatarImageView.image = imageArray[1]
        }
        else
        {
            self.networkController.fetchUserImage(singleTweet!, isSmallerImage: false, completionHandler:  //add logic for downloading the bigger image
            { (image) -> (Void) in
                self.avatarImageView.image = image
            })
        }
        
        self.twitterNameLabel.text = singleTweet?.name
        self.twitterHandleLabel.text = singleTweet?.handle
        self.tweetBodyLabel.text = singleTweet?.text
        self.timeStampLabel.text = singleTweet?.timeStamp

        //let normalRange = avatarString?.rangeOfString("_normal", options: nil, range: nil, locale: nil)
        //let newString = avatarString?.stringByReplacingCharactersInRange(normalRange!, withString: "_bigger")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //image stuff
        self.avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        self.avatarImageView.layer.borderWidth = 0.5
        self.avatarImageView.layer.borderColor = UIColor.grayColor().CGColor
        self.avatarImageView.layer.masksToBounds = true
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
    }

    // MARK: - This stupid thing
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
