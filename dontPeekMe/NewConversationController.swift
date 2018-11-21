//
//  NewConversationController.swift
//  dontPeekMe
//
//  Created by Neil Warren on 11/20/18.
//  Copyright © 2018 Neil Warren. All rights reserved.
//

import UIKit

class NewConversationController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let cellID = "cellID"
    var users = [User(email: "neil.p.warren@gmail.com", phoneNumber: "4088872622")]
    var tableView: UITableView!
    
    let phoneInputContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray
        
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = UIKeyboardType.numberPad
        textField.placeholder = "Enter a phone number..."
        return textField
    }()
    
    let searchButton: UIButton = {
        let search = UIButton()
        search.setImage(UIImage(named: "search.png"), for: .normal)
        search.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -16, bottom: 0, right: 4)
        search.frame = CGRect(x: CGFloat(UIScreen.main.bounds.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        search.addTarget(self, action: #selector(attemptSearch), for: .touchUpInside)
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.addSubview(phoneInputContainerView)
        NSLayoutConstraint.activate([
            phoneInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            phoneInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            phoneInputContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            phoneInputContainerView.heightAnchor.constraint(equalToConstant: 36)])
        phoneInputContainerView.addSubview(inputTextField)
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: phoneInputContainerView.leadingAnchor, constant: 18),
            inputTextField.trailingAnchor.constraint(equalTo: phoneInputContainerView.trailingAnchor),
            inputTextField.centerYAnchor.constraint(equalTo: phoneInputContainerView.centerYAnchor)])
        inputTextField.rightView = searchButton
        inputTextField.rightViewMode = .always
        self.tableView = UITableView()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    @objc func attemptSearch() {
        dissmissKeyboard()
        let phoneNumber = inputTextField.text!
        Authorization.instance.searchUsers(phoneNumber: phoneNumber) { (errMsg, data) in
            guard errMsg == nil else{
                let alert = UIAlertController(title: "Error", message: errMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.users = data as! [User]
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        cell.detailTextLabel?.text = user.phoneNumber
        
        return cell
    }
}

class UserCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented!")
    }
}
