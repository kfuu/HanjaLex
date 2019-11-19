//
//  resultsCell.swift
//  HanjaLex
//
//  Created by Kevin Fu on 11/18/19.
//  Copyright © 2019 Kevin Fu. All rights reserved.
//

import UIKit

class resultsCell: UITableViewCell {

    @IBOutlet weak var hanjaLabel: UILabel!
    @IBOutlet weak var hangulLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    
    func setResult(result: HanjaInfo) {
        hanjaLabel.text = result.hanja
        hangulLabel.text = result.hangul
        englishLabel.text = result.english
    }
    

}
