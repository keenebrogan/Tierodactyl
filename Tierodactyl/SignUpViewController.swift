//
//  SignUpViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButtonO: UIButton!
    
    var userID: String = " "
    
    //database reference
    var ref = Database.database().reference()
    
    
    @IBAction func signupButton(_ sender: Any) {
        
        guard let email = emailAddress.text else {return}
        guard let password = password.text else {return}
        guard let name = username.text else {return}
        
        //creates user
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let _ = user{
                //checks uid
                if let uid = Auth.auth().currentUser?.uid{
                    self.userID = uid
                    print("user created")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges(completion: { (error) in
                        print("couldn't change name")
                    })
                    self.dismiss(animated: true, completion: nil)
                    //Adds to database every time a new user enters something
                    self.ref.child("users").child(uid).child(name).child("Sample").setValue(" ")
                    
                }
            }
            else{
                print(error.debugDescription)
            }
        }
        
        //adds to database once
        ref.child("Sample").child("List 1: Fruits").observeSingleEvent(of: .value, with: { (snapshot) in
            self.ref.child("Sample").child("List 1: Fruits").child("banana").setValue("1a")
            self.ref.child("Sample").child("List 1: Fruits").child("orange").setValue("2a")
            self.ref.child("Sample").child("List 1: Fruits").child("apple").setValue("3a")
            self.ref.child("Sample").child("List 1: Fruits").child("blueberry").setValue("4a")
            
            // ...
        })
        { (error) in
            print(error.localizedDescription)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if username.isFirstResponder {
            emailAddress.becomeFirstResponder()
            
        }
        else if emailAddress.isFirstResponder {
            password.becomeFirstResponder()
        }
        else {
            password.resignFirstResponder()
            signupButtonO.isEnabled = true
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAddress.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let HomeScreenViewController = segue.destination as? HomeScreenViewController{
            HomeScreenViewController.userID = self.userID
            HomeScreenViewController.name = self.username.text ?? " "
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
