////
////  CollectionViews.swift
////
////
////  Created by Margaret Hollis (student LM) on 2/20/20.
////
//
//import UIKit
//
//class CollectionViews: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//
//    init() {
//        self.myCollectionView = UICollectionView()
//        super.init(nibName: nil, bundle: nil)
//        self.setLayouts()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    var myCollectionView: UICollectionView
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath as IndexPath)
//        myCell.backgroundColor = UIColor.blue
//        return myCell
//    }
//
//    func setLayouts(){
//
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: 111, height: 100)
//        layout.scrollDirection = .horizontal
//
//        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        myCollectionView.delegate   = self
//        myCollectionView.dataSource = self
//        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
//        myCollectionView.backgroundColor = UIColor.white
//
//
//        //add constraints!
//        //        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        //        myCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        //        myCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        //        myCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
//        //        myCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//
//
//    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
//    {
//        print("User tapped on item \(indexPath.row)")
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//
//    }
//
//}
//
//
//
