//
//  PseudoVue.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class PseudoVue: UIView {
    
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var erreurLabel: UILabel!
    
    
    
    var connectionController: ConnectionController?
    var vue: UIView!
    var peutCreerPseudo = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        vue = chargerXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        vue = chargerXib()
    }
    
    func ajouterController(controller: ConnectionController) {
        self.connectionController = controller
        pseudoTextField.addTarget(self, action: #selector(texteMisAJour), for: .editingChanged)
        
    }

    @IBAction func actionValider(_ sender: Any) {
        if pseudoTextField.text != nil, peutCreerPseudo {
            BDD().miseAJourUtilisateur(dict: ["pseudo": pseudoTextField.text! as AnyObject], completion: {(utilisateur) -> (Void) in
                if  utilisateur != nil {
                    MOI = utilisateur!
                    //peut passer au suivant
                    self.connectionController?.versApp()
                }
            })
        }
        
    }
    @IBAction func actionRetour(_ sender: Any) {
        connectionController?.transition(vers: (connectionController?.connectionVue)!, transition: .transitionFlipFromLeft)
    }
    
    @objc func texteMisAJour(_ textField: UITextField) {
        guard let nouveauPseudo = textField.text else { return }
        if nouveauPseudo == "" {
            peutCreerPseudo = false
            erreurLabel.text = "Le nom d'utilisateur ne peut pas être vide"
        } else if nouveauPseudo.contains(" ") {
            peutCreerPseudo = false
            erreurLabel.text = "Le nom d'utilisateur ne peut pas contenir d'espace"
        } else if nouveauPseudo.count >= 20 {
            peutCreerPseudo = false
            erreurLabel.text = "Le pseudo est trop long"
        } else {
            BDD().pseudoExists(pseudo: nouveauPseudo) { (success, error) -> (Void) in
                guard success != nil, error != nil else { return }
                self.peutCreerPseudo = success!
                self.erreurLabel.text = error!
            }
        }
    }
    
    
}
