//
//  HomeScreenViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    //all the lists
    let tbView = UITableView()
    var lists : [SeparateLists] = []
    var stuff = ["List1"]
    
    var homeLists: [String: [TierViewController]] = [:]
    
    var button = UIButton()
    var bar = UIBarButtonItem()
    
    var text1 = "Hello!"
    var text2 = "Good bye!"
    
    
    //CREATE A DATABASE WITH ALL OF THE LISTS
    
    
    //protype cell
    
    
    //dictionary with name of list and array for list
    
    
    
    // array of homescreen object - extends table vew cell - has property of array of individual cells. when you add new list it will create the object that each list is
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        guard var count = lists?.count else {return 1}
    //        return count
    //        return 1
    //    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        if lists != nil{
    //            return lists![indexPath.row]
    //        }
    
    //        var cell = HomeScreenTableViewCell()
    //
    //        cell.textLabel?.text = "List 1"
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        if lists != nil{
        //            lists![indexPath.row]
        //        }
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var safeArea: UILayoutGuide!
    
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
    
    func setUpButton(){
        // 2. add to subview
        view.addSubview(button)
        // 3. add props
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.font = UIFont(name: "Helvetica Nue", size: 50)
        // 4. set up func when button pressed
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 400).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 1000).isActive = true
    }
    
    
    func setUpBarButton(){
        bar = UIBarButtonItem(image: UIImage(named: "ptiero" ), style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = bar
    }
    
    @objc func edit(){
        
        
//        stuff[indexPath.row] = input
    }
    
    @objc func add(){
        stuff.append("New List")
        for i in stuff{
            print(i)
        }
        self.tbView.reloadData()
        //        self.loadView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuff.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = stuff[indexPath.row]
        
        return cell
    }
    
    
    override func viewDidLoad() {
        setUpTable()
        setUpButton()
        setUpBarButton()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
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
