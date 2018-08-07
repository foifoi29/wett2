//
//  ModelExtension.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import Foundation
import UIKit


extension String {
    
    func codage() -> String {
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? self
    }
    
    
    func decodage() -> String {
        return removingPercentEncoding ?? self
    }
    
    func rect(largeur: CGFloat, font: UIFont) -> CGRect {
        let taille = CGSize(width: largeur, height: .greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: self).boundingRect(with: taille, options: options, attributes: [.font: font], context: nil)
    }
}

extension Double {
    
    func ilYA() -> String {
        let dateDuMoment = Date()
        let dateDuDouble = Date(timeIntervalSince1970: self)
        let calendrier = Calendar.current
        let components = calendrier.dateComponents([.month, .day, .hour, .minute], from: dateDuDouble, to: dateDuMoment)
        if let mois = components.month, mois > 0 {
            return "Il y a " + String(mois) + " mois"
        } else {
            if let jours = components.day, jours > 0 {
                if jours == 1 {
                    return "Il y a 1 jour"
                } else {
                    return "Il y a " + String(jours) + " jours"
                }
            } else {
                if let heures = components.hour, heures > 0 {
                    if heures == 1 {
                        return "Il y a 1 heure"
                    } else {
                        return "Il y a " + String(heures) + " heures"
                    }
                } else {
                    if let minutes = components.minute, minutes > 0 {
                        if minutes == 1 {
                            return "Il y a 1 minute"
                        } else {
                            return "Il y a " + String(minutes) + " minutes"
                        }
                    } else {
                        return "Il y a quelques secondes"
                    }
                }
            }
        }
    }
}











