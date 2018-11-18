//
//  MessageViewController.swift
//  dontPeekMe
//
//  Created by Warren Liang on 11/13/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

struct Message {
    let text: String
    let isIncoming: Bool
}

class MessageTableViewController: UITableViewController {
    
    fileprivate let cellId = "id"
    
    //array of messages
    var textMessages = [
        Message(text: "Hi", isIncoming: true), Message(text: "Wassup?", isIncoming: false),
        Message(text: "Wanna hang out", isIncoming: true),
        Message(text: "Hmmmm, I might not really have time this weekend. Do you think next weekend we can hang out? I have other things to do this week!", isIncoming: false),
        Message(text: "This code should have white background", isIncoming: true),
        Message(text: "This code should have blue background", isIncoming: false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register each cell to use custom cell
        tableView.register(MessagesTableViewCell.self, forCellReuseIdentifier: cellId)
        
        //remove lines in our table view
        tableView.separatorStyle = .none
        
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textMessages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MessagesTableViewCell
        
        //Sets the text and if its incoming or not for the view
        let chatMessage = textMessages[indexPath.row]
        //        cell.messageLabel.text = chatMessage.text
        //        cell.isIncoming = chatMessage.isIncoming
        
        cell.Message = chatMessage
        
        return cell
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
