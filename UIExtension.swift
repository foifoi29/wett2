//
//  UIExtension.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import SDWebImage

extension UIViewController {
    
    func clavier() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cacherClavier)))
    }
    
    @objc func cacherClavier() {
        self.view.endEditing(true)
    }
    
}

extension UIView {
    
    func chargerXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nomXib = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nomXib, bundle: bundle)
        let vue = nib.instantiate(withOwner: self, options: nil).first as! UIView
        vue.frame = bounds
        addSubview(vue)
        vue.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .white
        return vue
    }
    
    func creerActivityIndicator() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.frame = bounds
        blur.tag = 11
        addSubview(blur)
        
        let activity = UIActivityIndicatorView()
        activity.activityIndicatorViewStyle = .gray
        activity.color = .white
        activity.center = center
        activity.tag = 5
        activity.startAnimating()
        addSubview(activity)
    }
    
    func supprimmerActivityIndicator() {
        for view in subviews {
            if view.tag == 11 {
                view.removeFromSuperview()
            }
            if view.tag == 5, let activity = view as? UIActivityIndicatorView {
                activity.stopAnimating()
                activity.removeFromSuperview()
            }
        }
    }
    
}

extension UIImageView {
    func telecharger(imageUrl: String?) {
        image = #imageLiteral(resourceName: "profil-500")
        guard let string = imageUrl, string != "", let url = URL(string: string) else { return }
        sd_setImage(with: url, completed: nil)
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func mainGris() -> UIColor {
        return UIColor(r: 96, g: 96, b: 96)
    }
}



extension UILabel {
    func texteAvecAttributs(string1: String, string2: String) {
        let mutable = NSMutableAttributedString(string: string1, attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.black])
        mutable.append(NSMutableAttributedString(string: string2, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.darkGray]))
        attributedText = mutable
    }
}
