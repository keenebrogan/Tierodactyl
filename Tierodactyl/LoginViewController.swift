//
//  LoginViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
       
       @IBOutlet weak var password: UITextField!
       
       @IBOutlet weak var loginButtonO: UIButton!
       @IBAction func loginButton(_ sender: Any) {
           guard let email = username.text else {return}
           guard let password = password.text else {return}
           Auth.auth().signIn(withEmail: email, password: password) { (user, error)
               in
               if let _ = user {
                    print("user created")
                   self.dismiss(animated: false, completion: nil)
               }
               else {
                   print(error!.localizedDescription)
               }
           }
       }
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           if username.isFirstResponder {
               password.becomeFirstResponder()
           }
           else if password.isFirstResponder {
               password.resignFirstResponder()
               loginButtonO.isEnabled = true
           }
           return true
       }
       override func viewDidLoad() {
           super.viewDidLoad()

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
