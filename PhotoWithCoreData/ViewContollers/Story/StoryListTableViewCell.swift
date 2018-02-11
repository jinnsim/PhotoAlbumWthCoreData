//
//  StoryListTableViewCell.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 11..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//

import UIKit

class StoryListTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
