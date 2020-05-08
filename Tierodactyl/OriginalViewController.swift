//
//  OriginalViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit

class OriginalViewController: UIViewController {

    override func viewDidLoad() {
    
        
        self.navigationItem.leftBarButtonItems?.removeAll()
        self.navigationItem.rightBarButtonItems?.removeAll()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {

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
