//
//  UtilisateurCell.swift
//  Wettly
//
//  Created by Nathan Levy on 06/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

let UTILISATEUR_TB = "UtilisateurCell"

class UtilisateurCell: UITableViewCell {
    
    
    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var presentationLabel: UILabel!
    
    var utilisateur: Utilisateur!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }
    
    func miseEnPlace(utilisateur: Utilisateur) {
        self.utilisateur = utilisateur
        imageDeProfil.telecharger(imageUrl: self.utilisateur.imageUrl)
        let string2 = "\n" + self.utilisateur.prenom + " " + self.utilisateur.nom
        presentationLabel.texteAvecAttributs(string1: self.utilisateur.pseudo, string2: string2)
    }
    
}
