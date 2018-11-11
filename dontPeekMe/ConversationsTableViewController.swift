//
//  ConversationsTableViewController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/6/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit
import InitialsImageView

class ConversationsTableViewController: UITableViewController {
    
    var conversationNames = ["Neil Warren", "Addison", "Warren"]
    var testConversation = "This is a test conversation to see if text wrapping works correctly.  The text message preview should be able to show 3 lines of text before cutting off."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
    }

    func signOut(){
        UserDefaults.standard.setLoggedIn(value: false, name: "")
        let loginController = storyboard?.instantiateViewController(withIdentifier: "MainNavigation") as! UINavigationController
        present(loginController, animated: true, completion: {
            // Funcitonality to do later?
        })
    }
    @objc func handleSignOut() {
        let alertController = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Sign Out", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
            self.signOut()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversationNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! CustomTableViewCell
        
        // Configure the cell...
        
        let cellName = conversationNames[indexPath.row]
        cell.nameLabel.text = cellName
        cell.messageLabel.text = testConversation
        cell.messageLabel.sizeToFit()
        cell.thumbnailImageView.setImageForName(cellName, backgroundColor: nil, circular: true, textAttributes: nil, gradient: true)
        //cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.frame.size.width / 2
        //cell.thumbnailImageView.clipsToBounds = true

        return cell
    }

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
