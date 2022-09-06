//
//  NewChatTableViewCell.swift
//  ChatAppProject
//
//  Created by Admin on 16.06.2022.
//

import UIKit

class NewChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configur(_ model: SearchResults)  {
        userImage.image = UIImage(named: "user")
        mailLabel.text = model.email
        nameLabel.text = model.name
    }
}
