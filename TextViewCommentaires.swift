//
//  TextViewCommentaires.swift
//  Wettly
//
//  Created by Nathan Levy on 07/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class TextViewCommentaires: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
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
        
    }


}
