//
//  ConnectionVue.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class ConnectionVue: UIView {
    
    
    @IBOutlet weak var labelWettly: UILabel!
    @IBOutlet weak var boutonConnexion: WettlyBouton!
    @IBOutlet weak var emailTextfield: TextFieldConnexion!
    @IBOutlet weak var passwordTextField: TextFieldConnexion!
    
    var vue: UIView!
    var connectionController: ConnectionController?
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        vue = chargerXib()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        vue = chargerXib()
        
    }
    
    func ajoutController(controller: ConnectionController) {
        self.connectionController = controller
    }
    
    @IBAction func actionBoutonConnexion(_ sender: Any) {
        //Dialoguer avec ConnectionController
        connectionController?.validerConnection(adresseMail: emailTextfield.text, motDePasse: passwordTextField.text)
    }

}
