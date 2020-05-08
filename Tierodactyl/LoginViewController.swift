//
//  LoginViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email2: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var loginButtonO: UIButton!
    @IBAction func loginButton(_ sender: Any) {
        guard let email = email2.text else {return}
        guard let password = password.text else {return}
        
        print("yoohoo")
               print(email)
               print(password)
        
        Auth.auth().signIn(withEmail: email, password: password){(user, error)
            in
            if error == nil && user != nil {
                print("user found")
                self.dismiss(animated: false, completion: nil)
//                self.navigationController?.pushViewController(HomeScreenViewController(), animated: false)
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if email2.isFirstResponder {
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
        email2.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    //asynchronus data - reference database .observe
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("User ID: \(Auth.auth().currentUser?.uid ?? "0")")
        
        if let HomeScreenViewController = segue.destination as? HomeScreenViewController{
            HomeScreenViewController.userID = Auth.auth().currentUser?.uid ?? " "
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
