//
//  TextViewAvecHashtag.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class TextViewAvecHashtag: UITextView {
    
    var nsString: NSString?
    var attributedString: NSMutableAttributedString?
    var couleurDuHashtag = UIColor(r: 16, g: 78, b: 139)

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        miseEnPlace()
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        miseEnPlace()
    }
    
    func miseEnPlace() {
        backgroundColor = .clear
        isEditable = false
        isSelectable = false
        isScrollEnabled = false
    }
    
    func ajoutDuText(texte: String, date: Double?) {
        self.attributedString = NSMutableAttributedString(string: texte)
        if date != nil {
            self.attributedString?.append(NSAttributedString(string: "\n" + date!.ilYA(), attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.white]))  // couleur de la date de publication
        }
        
        self.nsString = NSString(string: texte)
        
        let range = NSRange(location: 0, length: (self.nsString?.length)!)
        self.attributedString?.addAttributes([.foregroundColor : UIColor.black, .font: UIFont.systemFont(ofSize: 16)], range: range)
        let mots = texte.components(separatedBy: [" ", "\n"])
        for mot in mots.filter({$0.hasPrefix("#")}) {
            let motRange = nsString!.range(of: mot)
            attributedString?.addAttributes([.foregroundColor: couleurDuHashtag], range: motRange)
            attributedString?.addAttribute(NSAttributedStringKey(rawValue: "Hashtag"), value: 1, range: motRange)
            attributedString?.addAttribute(NSAttributedStringKey(rawValue: "Clickable"), value: 1, range: motRange)
        }
        
        //ajoute gesture si on clique sur un hashtag
        let tap = UITapGestureRecognizer(target: self, action: #selector(hashtagTap(tapGesture:)))
        addGestureRecognizer(tap)
        
        attributedText = attributedString
    }
    
    @objc func hashtagTap(tapGesture: UITapGestureRecognizer) {
        guard let lettreTap = closestPosition(to: tapGesture.location(in: self)) else { return }
        guard let lettreRange = tokenizer.rangeEnclosingPosition(lettreTap, with: .character, inDirection: 1) else { return }
        let position = offset(from: beginningOfDocument, to: lettreRange.start)
        let longueur = offset(from: lettreRange.start, to: lettreRange.end)
        let attributedRange = NSMakeRange(position, longueur)
        let lettre = attributedText.attributedSubstring(from: attributedRange)
        guard lettre.string != " " else { return }
        let estCeUnHashtag = lettre.attribute(NSAttributedStringKey("Hashtag"), at: 0, longestEffectiveRange: nil, in: NSMakeRange(0, lettre.length))
        guard let motChoisi = tokenizer.rangeEnclosingPosition(lettreTap, with: .word, inDirection: 1) else { return }
        let motPosition = offset(from: beginningOfDocument, to: motChoisi.start)
        let motLongueur = offset(from: motChoisi.start, to: motChoisi.end)
        let motRange = NSMakeRange(motPosition, motLongueur)
        let monMot = attributedText.attributedSubstring(from: motRange)
        let monMotString = monMot.string
        
        guard estCeUnHashtag != nil else { return }
        //notificationCenter
        
        print("je suis un hastag -> \(monMotString)")
        
    }
}










