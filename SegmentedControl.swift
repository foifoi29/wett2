//
//  SegmentedControl.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class SegmentedControll: UISegmentedControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlace()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlace()
    }
    
    func miseEnPlace() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    
    }
}
