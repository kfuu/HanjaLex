//
//  infoCell.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/19/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit

class infoCell: UICollectionViewCell {
    @IBOutlet weak var collectionInfoLabel: UILabel!
    
    func setString(info: String) {
        self.collectionInfoLabel.text = info
    }
}
