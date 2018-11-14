//
//  MessagesCell.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/13/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    let messageView = UIView()
    let messageLabel = UILabel()
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    var Message: Message! {
        didSet {
            messageView.backgroundColor = Message.isIncoming ? .white : UIColor(red: 35, green: 84, blue: 157, alpha: 1)
            messageLabel.textColor = Message.isIncoming ? .black : .white
            
            messageLabel.text = Message.text
            
            if Message.isIncoming {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    var isIncoming: Bool! {
        didSet {
            messageView.backgroundColor = isIncoming ? .white : UIColor(red: 35, green: 84, blue: 157, alpha: 1)
            messageLabel.textColor = isIncoming ? .black : .white
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        messageView.backgroundColor = .yellow
        messageView.layer.cornerRadius = 12
        messageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(messageView)
        addSubview(messageLabel)
        
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints of our message label
        let labelConstraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            messageView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            messageView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            messageView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingConstraint = messageLabel.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
