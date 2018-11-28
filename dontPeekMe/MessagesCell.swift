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
    
    
    func configCell(message: Message, blurred: Bool) {
        self.message = message
        
        if message.sender == currentUser {
            sentMessageView.isHidden = false
            sentMessageLabel.text = message.message
            
            recievedMessageLbl.text = ""
            recievedMessageView.isHidden = true
            
            if blurred{
                setBlur(messageView: sentMessageView, tag: 98)
            } else {
                removeBlur(messageView: sentMessageView, tag: 98)
            }
        } else {
            sentMessageView.isHidden = true
            sentMessageLabel.text = ""
            
            recievedMessageLbl.text = message.message
            recievedMessageView.isHidden = false
            
            if blurred{
                setBlur(messageView: recievedMessageView, tag: 98)
            } else {
                removeBlur(messageView: recievedMessageView, tag: 98)
            }
        }
        
    }

    func setBlur(messageView: UIView, tag: Int){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
        blurView.clipsToBounds = true
        blurView.layer.cornerRadius = 12
        blurView.tag = tag
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(blurView)
        blurView.topAnchor.constraint(equalTo: messageView.topAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: messageView.trailingAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: messageView.leadingAnchor).isActive = true
    }
    
    func removeBlur(messageView: UIView, tag: Int){
        if let viewWithTag = messageView.viewWithTag(tag){
            viewWithTag.removeFromSuperview()
        }
    }
}
