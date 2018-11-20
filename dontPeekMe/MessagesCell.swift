//
//  MessagesCell.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/20/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {

    @IBOutlet weak var recievedMessageLbl: UILabel!
    @IBOutlet weak var recievedMessageView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    @IBOutlet weak var sentMessageView: UIView!
    
    var message: Message!
    var currentUser: String! //not sure if this will be necessary
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recievedMessageView.layer.cornerRadius = 12
        recievedMessageView.translatesAutoresizingMaskIntoConstraints = false
        sentMessageView.layer.cornerRadius = 12
        sentMessageView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(message: Message) {
        self.message = message
        
        if message.sender == currentUser {
            sentMessageView.isHidden = false
            sentMessageLabel.text = message.message
            
            recievedMessageLbl.text = ""
            recievedMessageView.isHidden = true
        } else {
            sentMessageView.isHidden = true
            sentMessageLabel.text = ""
            
            recievedMessageLbl.text = message.message
            recievedMessageView.isHidden = false
        }
    }

}
