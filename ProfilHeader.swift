//
//  ProfilHeader.swift
//  Wettly
//
//  Created by Nathan Levy on 03/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

let PROFIL_HEADER = "ProfilHeader"

class ProfilHeader: UICollectionReusableView {
    
    @IBOutlet weak var imageDeFond: UIImageView!
    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var abonnesLabel: UILabel!
    @IBOutlet weak var abonnementsLabel: UILabel!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var boutonModifierOuSuivre: WettlyBouton!
    @IBOutlet weak var textView: TextViewAvecHashtag!
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var boutonParamètre: WettlyBouton!
    
    
    var utilisateur: Utilisateur!
    var controller: ProfilController?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func miseEnPlace(controller: ProfilController, utilisateur: Utilisateur) {
        self.controller = controller
        self.utilisateur = utilisateur
        abonnesLabel.texteAvecAttributs(string1: String(utilisateur.abonnes.count), string2: "\n Abonnés")
        abonnementsLabel.texteAvecAttributs(string1: String(utilisateur.abonnements.count), string2: "\n Abonnements")
        pseudoLabel.texteAvecAttributs(string1: utilisateur.pseudo, string2: "\n" + utilisateur.prenom + " " + utilisateur.nom)
        textView.ajoutDuText(texte: utilisateur.desc, date: nil)
        imageDeFond.telecharger(imageUrl: utilisateur.imageUrl)
        imageDeProfil.telecharger(imageUrl: utilisateur.imageUrl)
        
        if utilisateur.id == MOI.id {
            boutonModifierOuSuivre.setTitle("Modifier", for: .normal)
        } else if utilisateur.abonnes.contains(MOI.id) {
            boutonModifierOuSuivre.setTitle("Unfollow", for: .normal)
        } else {
            boutonModifierOuSuivre.setTitle("Follow", for: .normal)
        }
    }
    
    
    @IBAction func actionBouton(_ sender: Any) {
        if boutonModifierOuSuivre.titleLabel?.text == "Modifier" {
            let nouveauController = ModifierController()
            controller?.navigationController?.pushViewController(nouveauController, animated: true)
        }
    }
    
    @IBAction func actionParamètre(_ sender: Any) {
        if boutonModifierOuSuivre.titleLabel?.text == "Modifier" {
            let parametreController = ParametreController()
            controller?.navigationController?.pushViewController(parametreController, animated: true)
        }
    }
    
    
    @IBAction func actionSegment(_ sender: Any) {
        if segmented.selectedSegmentIndex == 0 {
            controller?.postComplet = true
        } else if segmented.selectedSegmentIndex == 1 {
            controller?.postComplet = false
        } else {
            print("page pour les stats")
        }
        controller?.collectionView?.reloadData()
    }
    
    
    
    
}
