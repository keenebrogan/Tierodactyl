//
//  HomeScreenViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //tableview
    let tbView = UITableView()
    
    //All the lists? I don't think this does anything
    
    //Lists for the table
    var listNames = [String]()
    
    //user info
    var userID: String = ""
    var name: String = ""
    var password: String = ""
    
    //for adding
    var listNameTextField : UITextField!
    
    
    let firstTimeMess = "Welcome to pTIERodactyl! Here you can create as many tier lists as you want! As this is your first time using our product, please tap through the 'Example' tier list. When you are finished you can delete this list and add your own by using the buttons in the top right corner of your screen! Enjoy!"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
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
        //        tbView.backgroundColor = .white
        tbView.backgroundColor = .init(cgColor: CGColor.init(srgbRed: 61, green: 80, blue: 163, alpha: 0.0))
        
        tbView.delegate = self
        tbView.dataSource = self
        
        tbView.register(HomeScreenCell.self, forCellReuseIdentifier: "homeScreenCell")
        
    }
    
    
    //works with editing (see line 136)
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let moveObjTemp = listNames[sourceIndexPath.item]
        listNames.remove(at: sourceIndexPath.item)
        listNames.insert(moveObjTemp, at: destinationIndexPath.item)
        self.ref.child("List Names/\(userID)/\(listNames[destinationIndexPath.item])").setValue(destinationIndexPath.item-1)
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
        
        //this should work with the database
        self.ref.child("List Names/\(userID)/\(listNames[listNames.count - 1])/").setValue(listNames.count)
        
        self.tbView.reloadData()
    }
    // this returns the number of rows in the table which is the size of my array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNames.count
    }
    
    //this is your basic needed function
    //returns a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //this is a problem, I don't know why
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenCell", for: indexPath) as! HomeScreenCell
        cell.textLabel?.text = listNames[indexPath.row]
        
        cell.backgroundColor = .init(cgColor: CGColor.init(srgbRed: 61, green: 120, blue: 163, alpha: 1.0))
        
        return cell
    }
    
    
    func displayMessage(message:String){
        let alert = UIAlertController(title: "Welcome to pTIERodactyl!", message: message, preferredStyle: .alert)
        //create Decline button
        let okAction = UIAlertAction(title: "Ok!" , style: .destructive){ (action) -> Void in
        }
        //add task to tableview buttons
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
       
        self.performSegue(withIdentifier: "unwindd", sender: nil)

    }
    
    
    override func viewDidLoad() {
     
        //this sets up an example list
        self.ref.child("List Names/\(userID)/Fruits").setValue(1)
        listNames.append("Fruits")
        
        self.ref.child("List Names/\(userID)/Fruits/0/banana").setValue("a")
        self.ref.child("List Names/\(userID)/Fruits/0/apple").setValue("b")
        self.ref.child("List Names/\(userID)/Fruits/1/orange").setValue("a")
        self.ref.child("List Names/\(userID)/Fruits/1/blueberry").setValue("b")
        
        //this updates the tableview with lists already created by the user in the database
        ref.child("List Names").child(userID).observe(.childAdded, with: { (snapshot) in
            
            // Get ListName
            let listName = snapshot.key
            //let num = snapshot.value as? Int
            
            if !self.listNames.contains(listName){
                self.listNames.append(listName)
            }
            self.tbView.reloadData()
            
          
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        //this sets up the table (see line 52)
        setUpTable()
        
        super.viewDidLoad()
        
        //This line of code makes it so that you can't see the outline of cells when they aren't there. I can just delete this but I think it looks cool so idk
        tbView.tableFooterView = UIView(frame: CGRect.zero)
        
    }
    //this is for a first time users pop up
    override func viewDidAppear(_ animated: Bool) {
        if(!appDelegate.hasAlreadyLaunched){
            
            //set hasAlreadyLaunched to false
            appDelegate.sethasAlreadyLaunched()
            //display user agreement license
            displayMessage(message: self.firstTimeMess)
        }
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "Segue", sender: nil)
        
    }
    
    
    
    
    //This sends info to TierView
        override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "Segue"{
                if let indexPath = self.tbView.indexPathForSelectedRow{
                    let controller = segue.destination as! TierViewController
                    controller.listName = listNames[indexPath.row]
                    controller.userID = self.userID
                }
            }
        }
    
}

class HomeScreenCell: UITableViewCell{
    var title: String = ""
}
