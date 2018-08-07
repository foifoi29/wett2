//
//  CommentaireCell.swift
//  Wettly
//
//  Created by Nathan Levy on 07/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

let COMMENTAIRE_TB = "CommentaireCell"

class CommentaireCell: UITableViewCell {
    
    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var commentaireLabel: UILabel!
    
    var commentaire: Commentaire!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    
    }
    
    func miseEnPlace(commentaire: Commentaire) {
        self.commentaire = commentaire
        imageDeProfil.telecharger(imageUrl: self.commentaire.utilisateur.imageUrl)
        let string2 = "\n" + self.commentaire.utilisateur.prenom + " " + self.commentaire.utilisateur.nom
        nomLabel.texteAvecAttributs(string1: self.commentaire.utilisateur.pseudo, string2: string2)
        commentaireLabel.texteAvecAttributs(string1: self.commentaire.texte, string2: "\n" + self.commentaire.date.ilYA())
    }
    
}
