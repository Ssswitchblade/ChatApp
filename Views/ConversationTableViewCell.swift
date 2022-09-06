//
//  ConversationTableViewCell.swift
//  ChatAppProject
//
//  Created by Admin on 13.06.2022.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var userMessageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configur(with model: Conversation) {
        
        userImageView.image = UIImage(named: "user")
        userNameLabel.text = model.name
        userMessageLabel.text = model.latestMessage.text
    }
    
}
