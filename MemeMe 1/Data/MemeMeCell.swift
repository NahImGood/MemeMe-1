//
//  MemeMeCell.swift
//  MemeMe 1
//
//  Created by Eli Warner on 2/1/19.
//  Copyright © 2019 EGW. All rights reserved.
//

import UIKit

class MemeMeCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    let textStyle: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        NSAttributedString.Key.strokeWidth: -2.5
    ]
        
    override func awakeFromNib() {
  
    }
    
    func setLabelAttributes(label:UILabel){
        label.attributedText = NSMutableAttributedString(string: label.text!, attributes: textStyle)
    }
    

    
}
