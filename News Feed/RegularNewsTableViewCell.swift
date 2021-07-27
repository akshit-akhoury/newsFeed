//
//  RegularNewsTableViewCell.swift
//  News Feed
//
//  Created by Akshit Akhoury on 27/07/21.
//

import UIKit

class RegularNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
