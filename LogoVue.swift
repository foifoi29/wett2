//
//  LogoVue.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class LogoVue: UIView {
    
    var logoImageVue: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        miseEnPlace()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlace()
    }
    
    func miseEnPlace() {
        logoImageVue = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        logoImageVue.image = #imageLiteral(resourceName: "logo Wettly 1024x1024 1x")
        logoImageVue.contentMode = .scaleAspectFit
        logoImageVue.clipsToBounds = true
        addSubview(logoImageVue)
        
    }
 
}
