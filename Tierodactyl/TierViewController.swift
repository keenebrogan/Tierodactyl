//
//  ViewController.swift
//  multSection
//
//  Created by Margaret Hollis (student LM) on 3/31/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//
//need labels to stay on cell when dragged
//why does it get weird when I reload collection
//can only drag cells up, not down
import UIKit

class TierViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDragDelegate, UICollectionViewDropDelegate{
   
    //keeps track of the number of sections
    //this holds the number of cells as well as the text to go with each cell
    var words = [[UILabel]()]
    var cells : [firstCell] = []
    var cleared = false
    var deleteDoneButton : UIBarButtonItem!
    var longPressEnabled = false
    var isAnimate: Bool! = false
    
    var receivedData = ""
    
    @IBOutlet weak var removeBtn: UIButton!
    
    
    func loadRequest(){
        guard self.title != nil else {return}
    }
    
    
    //creating the collection view, adding some basc formatting, more later
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    
    //MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        //adds long press gesture and sends code to "@objc long" method when pressed down
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        collection.addGestureRecognizer(longPressGesture)
        
        setUpViews()
        
        //just makes sure that words is empty, kinda messed up without this...
        if !cleared {
            words.removeAll()
            cleared = true
        }
        
        self.deleteDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(TierViewController.doneButtonTouchUp))
        deleteDoneButton.isEnabled = false
        
    
    }
    //MARK: Navigation Items
    //adds a bar to the bottom of the screen that allows the user to add a tier or a cell
    override func viewWillLayoutSubviews() {
       let width = self.view.frame.width
        let height = self.view.frame.height
        
        //minus 40 puts it at the bottom of the screen but looks weird since text is cut off by home screen pull thing
       let navigationBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: height - 75, width: width, height: 75))
       self.view.addSubview(navigationBar)
       let navigationItem = UINavigationItem(title: "Navigation bar")
        //adds a button to bar, this is the plus bottom that calls addSect and pops some alerts up
       let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: nil, action: #selector(addSect))
       navigationItem.rightBarButtonItem = doneBtn
        navigationItem.title = "add a tier or cell"
        //adds a done button to the bottom left of the navigation controller so that this can be pressed when the cells are getting deleted
        navigationItem.leftBarButtonItem = deleteDoneButton
        
        //tells the bar to show the button
       navigationBar.setItems([navigationItem], animated: false)
        
    }
    
    //sets up the collection view, sets its delegates and datasources, registers its cell
    func setUpViews(){
        collection.delegate = self
        collection.dataSource = self
        collection.dragDelegate = self
        collection.dropDelegate = self
        collection.dragInteractionEnabled = true
        
        collection.register(firstCell.self, forCellWithReuseIdentifier: "cell")
       
        //this is a header that will be above each section
        collection.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "header")
        
        //constraints for the collection view
        view.addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collection.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collection.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    //height of the section headers
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
   
    //this adds text to section headers and this is where you can change their color
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
        //making sure that what is being edited is the header
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            sectionHeader.label.text = String(indexPath.section + 1)
            sectionHeader.backgroundColor = .gray
        
             return sectionHeader
        }
            
        else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
        
    }


    //number of sections in the collectionview
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return words.count
    }
    
    //number of cells in each section/tier
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return words[section].count
    }
    
    //this just sets up the basic cell
    //they are of type firstCell which does not have much of its own functionality
    //also adds whatever label goes with it
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! firstCell
        
        setUpLabel(indexPath, cell)
        cell.contentView.addSubview(words[indexPath.section][indexPath.row])
      
        return cell
    }
    
    //this customzes labels that go on the cell and allows the text to be more than one line, formats label
    func setUpLabel(_ indexPath: IndexPath, _ cell: firstCell){
        cells.append(cell)
        words[indexPath.section][indexPath.row].lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        words[indexPath.section][indexPath.row].numberOfLines = 0
        words[indexPath.section][indexPath.row].frame = CGRect(x: 5, y: 0, width: cell.frame.width-5, height: cell.frame.height)
        words[indexPath.section][indexPath.row].font = UIFont(name: "Helvetica", size: 20)
        words[indexPath.section][indexPath.row].textColor = .white
    }
    
    //this is where you change the cell sizes
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.width / 3) - 16, height: 100)
    }
    
    //this is the space around the sections, how far from the edge and other sections a tier is
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 30, right: 0)
    }
    
    //adding text/editing a cell
    //also deleting a cell if "longPressEnabled is true"
    //MARK: Edit Text/Delete
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        //if true, goes through the motions of deleting the cell that was clicked.
        if longPressEnabled{
            
//            let alert = UIAlertController(title: "Are you sure you want to delete this cell?", message: "", preferredStyle: UIAlertController.Style.alert)
            
            
//            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                self.words[indexPath.section][indexPath.row].text = nil
                self.words[indexPath.section].remove(at:indexPath.row)
            
            
            if words[indexPath.section].count == 0{
                words.remove(at: indexPath.section)
            }
           
                
                collectionView.reloadData()
//                cellStopShake()
//                cellShake()
           

//            }))
            
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
               
            
//            }))
            

        }
        else{
        //an alert pops up when you click on a cell
        let alert = UIAlertController(title: "Edit Cell", message: "Enter the text you would like to add to this cell", preferredStyle:
                   UIAlertController.Style.alert)

        //text field which allows the user to add or edit the text of a cell
               alert.addTextField(configurationHandler: textFieldHandler)
        //adds and pre exisiting text to the text box so they can change it without re typing it
               alert.textFields?.first!.text = words[indexPath.section][indexPath.row].text

        //does nothing, just closes the alert
               alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                   
               }))
        //this adds the text
               alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                
                //clears the view so no overlappign labels
                    collectionView.cellForItem(at: indexPath)?.contentView.subviews.forEach({ $0.removeFromSuperview() })
                
                //a stand in label that will be used to put the text on the cell
                    let label = UILabel()
                    label.text = (alert.textFields?.first!.text)!
                        
                //label formatting
                    label.font = UIFont(name: "Times New Roman", size: 30)
                    label.textColor = .black
                    label.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                        
                //adds the label to the cell and then reloads everything
                    self.words[indexPath.section][indexPath.row] = label
                    collectionView.reloadData()
    
               }))

            self.present(alert, animated: true, completion:nil)
        }
    }
    
    
    //sets up the text field for the alert
    func textFieldHandler(textField: UITextField!) {
        if (textField) != nil {
               textField.text = ""
        }
    }
    
 
    //drag and drop stuff
    //this is when you are dropping the cell into its new place
    //it finds the desitination and makes it the new index path for the cell unless the destination is nil
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
           var destinationIndexPath: IndexPath
        
           if let indexPath = coordinator.destinationIndexPath{
               destinationIndexPath = indexPath
           }
            //if nil then it places at the end of whatever section the cell is above
           else{
            let row = collectionView.numberOfItems(inSection: 0)
            //if having issue with dropping on end, maybe remove "-1"
               destinationIndexPath = IndexPath(row: row - 1, section: 0)
           }
           
        //after the move is made it calls reorderItems to rearrange the cells and sort everything out
           if coordinator.proposal.operation == .move{
               self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
           
           }
    }
    
    fileprivate func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath:IndexPath, collectionView: UICollectionView){
       
        if let item = coordinator.items.first,
            let sourceIndexPath = item.sourceIndexPath{
          
            collectionView.performBatchUpdates({
               
                //moves the cell from one location to the other
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
                
                var label = words[sourceIndexPath.section][sourceIndexPath.row]
                
                //self.words[sourceIndexPath.section][sourceIndexPath.row].text = nil
                words[sourceIndexPath.section].remove(at: sourceIndexPath.row)
                
                //moves the labels from the old cell to the new one
                words[destinationIndexPath.section].insert(label, at: destinationIndexPath.row)
               
               
                
                }, completion: nil)
            
            //finally, the drop is completed
             coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
        
    }
    
    //makes sure the drop is complete and if it isnt, this completes it
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag{
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    //identifies what is being dragged
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        var item = ""
        //testing something new out, might now work
        
        if words[indexPath.section][indexPath.row].text != nil{
            item = words[indexPath.section][indexPath.row].text!
        }
        //String(indexPath.row + 1)
        let itemProvider = NSItemProvider(object: item as NSString)
           let dragItem = UIDragItem(itemProvider: itemProvider)
           dragItem.localObject = item
           return [dragItem]
       }
    
  
    //this is the functionality of the bottom on the bottom of the screen
     @objc func addSect(){
      
        //an alert will pop up
        let alert = UIAlertController(title: "Edit Cell", message: "", preferredStyle:
                          UIAlertController.Style.alert)

                 
        //adds a section with one cell, updates secCount to have the right number of sections
        //reloads everything
                      alert.addAction(UIAlertAction(title: "Add Tier", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                        self.words.append([UILabel()])
                        self.collection.reloadData()
                           
                      }))

    //if they want to add a cell, this alert will close and another will open (in the func addCell)
                      alert.addAction(UIAlertAction(title: "Add Cell", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
                         
                        self.addCell()
                      
                      }))
        
    //does nothing, closes alert
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in

                    }))

                   self.present(alert, animated: true, completion:nil)
        
        }
    
//if the user wants to add a cell (selected above) this function is called
    func addCell(){
        let alert = UIAlertController(title: "Edit Cell", message: "Enter the tier you would like to add a cell to", preferredStyle: UIAlertController.Style.alert)

        //text box so they can say which section they want the cell to be in
            alert.addTextField(configurationHandler: textFieldHandler)

        //this is called when they click add cell
            alert.addAction(UIAlertAction(title: "Add Cell", style: UIAlertAction.Style.default, handler:{ (UIAlertAction) in
               
                //makes sure that the number entered into the textbox is a valid integer
                guard let index = Int((alert.textFields?.first!.text)!) else {return}
                
                //makes sure a corresponding section exists
                if index <= self.words.count{
                    //adds a label to words to account for one more cell and reloads everything
                    self.words[index-1].append(UILabel())
                    self.collection.reloadData()
//                    self.cellShake()
                }
                                   
            }))
                       
            self.present(alert, animated: true, completion:nil)
    }
    
    //MARK: Delete Functions
    
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
//MARK: Add Later
  //          doneBtn.isHidden = false
 //           longPressedEnabled = true
            self.collection.reloadData()
        default:
            collection.cancelInteractiveMovement()
        }
    }
//MARK: Done Button
    @IBAction func doneButtonTouchUp(deleteDoneButton sender: UIBarButtonItem) {
        deleteDoneButton.isEnabled = false
        isAnimate = false
        longPressEnabled = false
        cellStopShake()
        
    }

    @objc func long(){
        self.deleteDoneButton.isEnabled = true
        longPressEnabled = true
        isAnimate = true
        cellShake()
        

    
    }
    func cellShake(){
        for c:firstCell in cells{
            c.shake()
        }
    }
    func cellStopShake(){
        for c:firstCell in cells{
    c.stopShaking()
        }
    }
}

//a class for the cells, just changes background color and gives a lil curve to the corners
class firstCell: UICollectionViewCell{

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 10
        
    }
    
    
    //MARK: Animation
    func shake() {
        let shakeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        shakeAnimation.duration = 0.05
        shakeAnimation.repeatCount = 2
        shakeAnimation.autoreverses = true
        let startAngle: Float = (-2) * 3.14159/180
        let stopAngle = -startAngle
        shakeAnimation.fromValue = NSNumber(value: startAngle as Float)
        shakeAnimation.toValue = NSNumber(value: 3 * stopAngle as Float)
        shakeAnimation.autoreverses = true
        shakeAnimation.duration = 0.15
        shakeAnimation.repeatCount = 10000
        shakeAnimation.timeOffset = 290 * drand48()

        let layer: CALayer = self.layer
        layer.add(shakeAnimation, forKey:"shaking")
    }

    func stopShaking() {
        let layer: CALayer = self.layer
        layer.removeAnimation(forKey: "shaking")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//this is the class for the header above each section
class SectionHeader: UICollectionReusableView {
    //creates the label that the headers have to say which section it is, formats it
     var label: UILabel = {
     let label: UILabel = UILabel()
     label.textColor = .white
     label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
     label.sizeToFit()
     return label
 }()

    //provides constraints for the label on the header and adds the label to the headers view so it will show up
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




