//
//  WettlyBouton.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class WettlyBouton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlace()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlace()
    }
    
    func miseEnPlace() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        backgroundColor = UIColor(r: 80, g: 101, b: 161)
        tintColor = .darkGray
    }
    

}
