//
//  TextFieldConnexion.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class TextFieldConnexion: UITextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlace()
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlace()
    
    }
    
    func miseEnPlace() {
        layer.borderColor = UIColor(r: 96, g: 96, b: 96).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        
    }
}
