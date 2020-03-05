////
////  CellClass.swift
////  Tierodactyl
////
////  Created by Margaret Hollis (student LM) on 2/22/20.
////  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
////
//
//import UIKit
//
//class CellClass: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
//
//    var cellsForFrame : [UICollectionViewCell]? = []
//
//
//    //the collection view that will be in each tableview row
//    var collectionView: UICollectionView!
//    var counter = 0
//    
//    //created individual cell for the collection view
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! UICollectionViewCell
//        
//        // if cellsForFrame != nil{
//        
//        // cellsForFrame?.append(cell)
//        
//        cell.layer.cornerRadius = 10
//        cell.backgroundColor = .black
//        if indexPath.row != 0{
//            cell.frame = CGRect(x: /*(cellsForFrame?[indexPath.row].frame.maxX)!*/ 60*indexPath.row + 10, y: 10, width: 50, height: 50)
//        }
//        else{
//            cell.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
//        }
//        // }
//        
//        return cell
//        
//    }
//    
//    //creates the collectionview
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        
//        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView.frame = CGRect(x: 0, y: 0, width: 314 , height: 70)
//        //how do i get the width? like when the screen is a different size?
//        collectionView.backgroundColor = .white
//        collectionView.allowsSelection = true
//        collectionView.dragInteractionEnabled = true
//        collectionView.dragDelegate = self
//    
//        
//        self.addSubview(collectionView)
//        
//    }
//    
//    //irrelevant
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//    }
//    
//    // MARK: UICollectionViewDataSource
//    //also irrelevant
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    // number of cells in a collectionview, this will be made similar to corresponding class in TierVC
//    //when we create funcationality to add elements to each row
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return counter
//    }
//    
//    //irrelevant
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//    
//    //also irrelevant
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//    }
//}
//
//extension CellClass: UICollectionViewDragDelegate{
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at
//             indexPath: IndexPath) -> [UIDragItem] {
//             let item = ""
//             let itemProvider = NSItemProvider(object: item as NSString)
//             let dragItem = UIDragItem(itemProvider: itemProvider)
//             dragItem.localObject = item
//             return [dragItem]
//         }
//}
//
////extension CellClass: UITableViewDropDelegate{
////    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
////        let destinationIndexPath: IndexPath
////        if let indexPath = coordinator.destinationIndexPath {
////            destinationIndexPath = indexPath
////        }
////        else{
////            let section = tableView.numberOfSections - 1
////            let row = tableView.numberOfRows(inSection: section)
////            destinationIndexPath = IndexPath(row: row, section: section)
////        }
////
////    }
////    
//
//    
//    
//    
////}
//
//
