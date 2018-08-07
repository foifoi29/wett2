//
//  HashtagCell.swift
//  Wettly
//
//  Created by Nathan Levy on 06/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

let HASHTAG_TB = "HashtagCell"

class HashtagCell: UITableViewCell {
    
    @IBOutlet weak var texte: UILabel!
    
    var hashtag: Hashtag!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func miseEnPlace(hashtag: Hashtag) {
        self.hashtag = hashtag
        var string2: String = "\n"
        if self.hashtag.posts.count <= 1 {
            string2 += String(self.hashtag.posts.count) + " mention"
        } else {
            string2 += String(self.hashtag.posts.count) + " mentions"
        }
        
        texte.texteAvecAttributs(string1: self.hashtag.nom, string2: string2)
    }
    
}
