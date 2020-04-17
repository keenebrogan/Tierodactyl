//
//  ViewController.swift
//  multSection
//
//  Created by Margaret Hollis (student LM) on 3/31/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

//need labels to stay on cell when dragged
//why does it get weird when I reload collection
import UIKit

class TierViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
   
    var secCount = 0
    var words = [[UILabel]()]
    var cleared = false
    
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTap(_:)))
        collection.addGestureRecognizer(longPressGesture)
        
        
        setUpViews()
        
        if !cleared {
            words.removeAll()
            cleared = true
        }
    
    }
    
    override func viewWillLayoutSubviews() {
       let width = self.view.frame.width
        let height = self.view.frame.height
        
        //minus 40 puts it at the bottom of the screen but looks weird since text is cut off by home screen pull thing
       let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: height - 75, width: width, height: 75))
       self.view.addSubview(navigationBar)
       let navigationItem = UINavigationItem(title: "Navigation bar")
       let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(addSect))
       navigationItem.rightBarButtonItem = doneBtn
        navigationItem.title = "add a tier"
 
       navigationBar.setItems([navigationItem], animated: false)
        
    }
    
    func setUpViews(){
        collection.delegate = self
        collection.dataSource = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        collection.dragInteractionEnabled = true
        
        collection.register(firstCell.self, forCellWithReuseIdentifier: "cell")
       
        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "header")
        
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = String(indexPath.section + 1)
            sectionHeader.backgroundColor = .gray
            
            var button = UIButton()
            
            view.addSubview(button)
            
            button.setTitle("ADD CELL", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor.gray
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
           
            button.addTarget(self, action: #selector(addCell), for: .touchUpInside)
            //HOW DO I ADD ADDCELL THE INDEXPATHHHHHHHHHH
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.topAnchor.constraint(equalTo: sectionHeader.topAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: sectionHeader.label.rightAnchor).isActive = true
            button.rightAnchor.constraint(equalTo: sectionHeader.rightAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: sectionHeader.bottomAnchor).isActive = true
        
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
    
    @objc func addCell(){
       // words[indexPath.section].append(UILabel())
        collection.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return secCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! firstCell
        
        cell.contentView.addSubview(words[indexPath.section][indexPath.row])
      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.width / 3) - 16, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
    }
    
    //adding text/editing a cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        let alert = UIAlertController(title: "Edit Cell", message: "", preferredStyle:
                   UIAlertController.Style.alert)

               alert.addTextField(configurationHandler: textFieldHandler)

               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                   
               }))

               alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                
                    collectionView.cellForItem(at: indexPath)?.contentView.subviews.forEach({ $0.removeFromSuperview() })
                 
                    let cell = collectionView.cellForItem(at: indexPath) as! firstCell
                
                    let label = UILabel()
                    label.text = (alert.textFields?.first!.text)!
                        
                    label.font = UIFont(name: "Times New Roman", size: 30)
                    label.textColor = .black
                    label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                        
                    self.words[indexPath.section][indexPath.row] = label
                    collectionView.reloadData()
    
               }))

            self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldHandler(textField: UITextField!) {
        if (textField) != nil {
               textField.text = ""
        }
    }
    
    
    //drag and drop stuff
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
           var destinationIndexPath: IndexPath
        
           if let indexPath = coordinator.destinationIndexPath{
               destinationIndexPath = indexPath
           }
           else{
            let row = collectionView.numberOfItems(inSection: 0)
               destinationIndexPath = IndexPath(row: row - 1, section: 0)
           }
           
           if coordinator.proposal.operation == .move{
               self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
           
           }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView){
       
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath{
          
            collectionView.performBatchUpdates({
               
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                
                words[destinationIndexPath.section].insert(words[sourceIndexPath.section][sourceIndexPath.row], at: destinationIndexPath.row)
                words[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                
                }, completion: nil)
            
             coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
           let item = String(indexPath.row + 1)
           let itemProvider = NSItemProvider(object: item as NSString)
           let dragItem = UIDragItem(itemProvider: itemProvider)
           dragItem.localObject = item
           return [dragItem]
       }
    
  
     @objc func addSect(){
           secCount+=1
           words.append([UILabel(),UILabel()])
        //   words[words.count-1].removeAll()
           collection.reloadData()
        }
    
    //MARK: DELETE CELL FUNCTIONS
    
    @objc func longTap(_ gesture: UIGestureRecognizer){
        
        switch(gesture.state) {
        case .began:
            guard let selectedIndexPath = collection.indexPathForItem(at: gesture.location(in: collection)) else {
                return
            }
            collection.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collection.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collection.endInteractiveMovement()
//MARK: ADD LATER            doneBtn.isHidden = false
 //           longPressedEnabled = true
            self.collection.reloadData()
        default:
            collection.cancelInteractiveMovement()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallImgCell.identifier, for: indexPath) as! SmallImgCell
//        cell.backgroundColor = UIColor.clear
//
//        cell.imgView.image = UIImage(named: "\(imgArr[indexPath.row])")
//
////        cell.removeBtn.addTarget(self, action: #selector(removeBtnClick(_:)), for: .touchUpInside)
//
////        if longPressedEnabled   {
////            cell.startAnimate()
////        }else{
////            cell.stopAnimate()
////        }
//
//        return cell
//    }
    
//
//    func startAnimate() {
//        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
//        shakeAnimation.duration = 0.05
//        shakeAnimation.repeatCount = 4
//        shakeAnimation.autoreverses = true
//        shakeAnimation.duration = 0.2
//        shakeAnimation.repeatCount = 99999
//
//        let startAngle: Float = (-2) * 3.14159/180
//        let stopAngle = -startAngle
//
//        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
//        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
//        shakeAnimation.autoreverses = true
//        shakeAnimation.timeOffset = 290 * drand48()
//
//        let layer: CALayer = self.layer
//        layer.add(shakeAnimation, forKey:"animate")
//        removeBtn.isHidden = false
//        isAnimate = true
//    }
//
//
//    func stopAnimate() {
//        let layer: CALayer = self.layer
//        layer.removeAnimation(forKey: "animate")
//        self.removeBtn.isHidden = true
//        isAnimate = false
//    }
//
//    @IBAction func removeBtnClick(_ sender: UIButton)   {
//        let hitPoint = sender.convert(CGPoint.zero, to: self.collection)
//        let hitIndex = self.imgcollection.indexPathForItem(at: hitPoint)
//
//        //remove the image and refresh the collection view
//        self.imgArr.remove(at: (hitIndex?.row)!)
//        self.collection.reloadData()
//    }
//
//    @IBAction func doneBtnClick(_ sender: UIButton) {
//        //disable the shake and hide done button
//        doneBtn.isHidden = true
//        longPressedEnabled = false
//
//        self.collection.reloadData()
//    }
    
    
    
}

class firstCell: UICollectionViewCell{

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class SectionHeader: UICollectionReusableView {
     var label: UILabel = {
     let label: UILabel = UILabel()
     label.textColor = .white
     label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
     label.sizeToFit()
     return label
 }()

override init(frame: CGRect) {
     super.init(frame: frame)

     addSubview(label)

     label.translatesAutoresizingMaskIntoConstraints = false
     label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
     label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
    label.rightAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
}

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}







