//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Jacob Hawken on 10/7/14.
//  Copyright (c) 2014 Jacob Hawken. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell
{
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetAvatar: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
