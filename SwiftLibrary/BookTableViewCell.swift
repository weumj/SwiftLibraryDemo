//
//  BookTableViewCell.swift
//  SwiftLibrary
//
//  Created by mj on 2016. 5. 22..
//  Copyright © 2016년 mj. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageThumb: UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    @IBOutlet weak var labelAuthor : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
