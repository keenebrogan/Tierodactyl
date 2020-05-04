//
//  HomeScreenViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //tableview
    let tbView = UITableView()
    
    //All the lists? I don't think this does anything
    var lists : [SeparateLists] = []
    
    //Lists for the table
    var listNames = ["Sample"]
    
    //userID and username for Database
    var userID: String = " "
    var name: String = " "
    
    //for adding
    var listNameTextField : UITextField!
    
    //I don't think this does anything right now
    var homeLists: [String: [TierViewController]] = [:]
    
//    var button = UIButton()
//    var bar = UIBarButtonItem()
    
 
    //database instance
    var ref = Database.database().reference()
    
    
    //Notes to self:
    //CREATE A DATABASE WITH ALL OF THE LISTS
    //protype cell
    //dictionary with name of list and array for list
    // array of homescreen object - extends table vew cell - has property of array of individual cells. when you add new list it will create the object that each list is
    
    
    var safeArea: UILayoutGuide!
    
    //this sets up our tableview
    func setUpTable(){
        view.addSubview(tbView);
        tbView.translatesAutoresizingMaskIntoConstraints = false
        tbView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tbView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tbView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tbView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        safeArea = view.layoutMarginsGuide
        tbView.backgroundColor = .white
        
        
        //var tableView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        
        //tableView.register(HomeScreenTableViewCell(), forCellReuseIdentifier: "MyCell")
        
        //     view.addSubview(tableView)
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
//      I used to have a button here, will delete later
//    func setUpButton(){
//        // 2. add to subview
//        view.addSubview(button)
//        // 3. add props
//        button.setTitle("+", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .blue
//        button.titleLabel?.font = UIFont(name: "Helvetica Nue", size: 75)
//        // 4. set up func when button pressed
//        button.addTarget(self, action: #selector(addAction), for: .touchUpInside)
//
//       button.addTarget(self, action: #selector(addAction()), for: .touchUpInside)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 400).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        button.widthAnchor.constraint(equalToConstant: 1000).isActive = true
//    }
    
    
    //works with editing (see line 136)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObjTemp = listNames[sourceIndexPath.item]
        listNames.remove(at: sourceIndexPath.item)
        listNames.insert(moveObjTemp, at: destinationIndexPath.item)
    }
    
    // works with deleting (see line 136)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            listNames.remove(at: indexPath.item)
            tbView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    //This allows you to rearrange the lists and delete them
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        self.tbView.isEditing = !self.tbView.isEditing
        if self.tbView.isEditing{
            sender.title = "Done"
        }
        else{
            sender.title = "Edit"
        }
    }
    
    //This allows adding lists
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        let alertcontroller = UIAlertController(title: "Add List", message: nil, preferredStyle: .alert)
        alertcontroller.addTextField(configurationHandler: listNameTextField)
        
        let okAction = UIAlertAction(title: "Add", style: .default, handler: self.okHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertcontroller.addAction(okAction)
        alertcontroller.addAction(cancelAction)
        
        self.present(alertcontroller, animated: true)
    }
    
    //this is the text field for the alert so that we can add Lists
    func listNameTextField(textField: UITextField!){
        listNameTextField = textField
        listNameTextField.placeholder = "List name here"
    }
    //this is the function for the alert
    func okHandler(alert : UIAlertAction){
        listNames.append(listNameTextField.text ?? " ")
        
        //this should work with the database, I don't think it works yet though
        self.ref.child("users").child(userID).child(name).child(listNames[listNames.endIndex - 1]).setValue(" ")
        
        self.tbView.reloadData()
    }
    // this returns the number of rows in the table which is the size of my array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    //this is your basic needed function
    //returns a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listNames[indexPath.row]
        
        return cell
    }
    
    
    override func viewDidLoad() {
        setUpTable()
//        setUpButton()
        super.viewDidLoad()
        
        //This line of code makes it so that you can't see the outline of cells when they aren't there. I can just delete this but I think it looks cool so idk
        tbView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    
    //This does nothing - working on it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (sender as? HomeScreenTableViewCell) != nil{
            if segue.destination is TierViewController{
                //tierViewController.list = homeLists
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
