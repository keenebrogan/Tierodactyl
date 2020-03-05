//
//  CollectionViewCell.swift
//  Tierodactyl
//
//  Created by Margaret Hollis (student LM) on 2/28/20.
//  Copyright © 2020 Margaret Hollis (student LM). All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var text = UILabel()
    
   func setProps(){
       text.font = UIFont(name: "Times New Roman", size: 20)
        text.textColor = .black
        
   }
    
}
