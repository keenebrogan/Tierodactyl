//
//  TierViewController.swift
//  Tierodactyl
//
//  Created by Anne Hamilton (student LM) on 2/19/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit

class TierViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate{
    
    //keeps track of how many rows to print out - needed because array is optional
    var counter = 0
    //array of optional cells, each one represents a row
    
    var cells : [IndividualCollectionView] = []
   
    var collection = IndividualCollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: UICollectionViewFlowLayout())
    
    var source = IndexPath()
    
    // number of cells in a collectionview, this will be made similar to corresponding class in TierVC
    //when we create funcationality to add elements to each row
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var collection = collectionView as! IndividualCollectionView
        
        return  collection.count //need separate value for each collectionview
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewCell", for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.backgroundColor = .green
        cell.setProps()
        cell.text.text = String(indexPath.row+1)
        cell.addSubview(cell.text)
        cell.text.translatesAutoresizingMaskIntoConstraints = false
        cell.text.heightAnchor.constraint(equalToConstant: cell.frame.height).isActive = true
        cell.text.widthAnchor.constraint(equalToConstant: cell.frame.width).isActive = true
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        //this collectionview is what you are dragging from
        collection = collectionView as! IndividualCollectionView
        source = indexPath
        
        let item = ""
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: IndividualCollectionView){
        
        if let item = coordinator.items.first{
            
            collectionView.reloadData()
            collection.reloadData()
            
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [destinationIndexPath])
                collectionView.count+=1
            }, completion: nil)
            
            
            collection.performBatchUpdates({
                collection.deleteItems(at: [source])
                collection.count-=1
            }, completion: nil)
            
            
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            
            
        }
        
        collectionView.reloadData()
        collection.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        
        
        if let indexPath = coordinator.destinationIndexPath{
            destinationIndexPath = indexPath
        }
        else{
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move{
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView as! IndividualCollectionView)
        }
    }
    
    //this is called when you press the plus button, it adds another row
    @IBAction func add(_ sender: UIBarButtonItem) {
        counter+=1
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        cells.append(IndividualCollectionView(frame: view.bounds, collectionViewLayout: layout))
        
        // cells.append(IndividualCollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))
        self.tableView.reloadData()
        
    }
    
    //when green section of cell is clicked a collection view cell will be added
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cells[indexPath.row].count+=1
        cells[indexPath.row].reloadData()
        tableView.reloadData()
    }
    
    //sets row height for each table view row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0;//Choose your custom row height
    }
    
    //creates a row for the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //basically makes even rows green and odd system green
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        
        if cells.count > 0{
            var cell = cells.last
            cell?.register(CollectionViewCell.self, forCellWithReuseIdentifier: "ViewCell")
            cell!.delegate = self
            cell!.dataSource = self
            cell!.frame = CGRect(x: 0, y: 0, width: 314 , height: 70)
            cell!.backgroundColor = .white
            cell!.allowsSelection = true
            cell!.dragInteractionEnabled = true
            cell!.dragDelegate = self
            cell!.dropDelegate = self
            
            
            var table = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as! IndexPath) as! TierTableViewCell
            
            table.backgroundColor = .systemGray
            table.addSubview(cell!)
            return table
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as! IndexPath) as! TierTableViewCell
        
    }
    
    //when the table view is reloaed this sets the number of rows there will be
    //counter keeps track of the number of rows in the array of cells and returns it
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counter
    }
    
    //this is completley irrelevant, just keep it at one
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //also has no current function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection=true
        
        
    }
    
}


