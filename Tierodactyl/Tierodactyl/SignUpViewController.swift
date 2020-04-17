//
//  SignUpViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signupButtonO: UIButton!
    
    @IBAction func signupButton(_ sender: Any) {
         
         guard let email = emailAddress.text else {return}
         guard let password = password.text else {return}
         guard let name = username.text else {return}
        
         Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
             if let _ = user{
                  print("user created")
                 let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                 changeRequest?.displayName = name
                 changeRequest?.commitChanges(completion: { (error) in
                     print("couldn't change name")
                 })
                  self.dismiss(animated: true, completion: nil)
             }
             else{
                 print(error.debugDescription)
             }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
