//
//  ConnectionController.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import Firebase

class ConnectionController: UIViewController {
    
    var logoVue: LogoVue!
    var vueActuelle: UIView!
    var connectionVue: ConnectionVue!
    var pseudoVue: PseudoVue!
    
    var monMail: String?
    var monMdp: String?
    var monPseudo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        clavier()
        view.backgroundColor = .white
        logoVue = LogoVue(frame: view.bounds)
        connectionVue = ConnectionVue(frame: view.bounds)
        connectionVue.ajoutController(controller: self)
        pseudoVue = PseudoVue(frame: view.bounds)
        pseudoVue.ajouterController(controller: self)
        view.addSubview(logoVue)
        vueActuelle = logoVue

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let id = Auth.auth().currentUser?.uid {
            verifierUtilisateur(id: id)
            
        } else {
            transition(vers: connectionVue, transition: .transitionFlipFromLeft)
        }
    }
    
    func validerConnection(adresseMail: String?, motDePasse: String?) {
        monMail = adresseMail
        monMdp = motDePasse
        if let mail = monMail, mail != "" {
            if let mdp = monMdp, mdp != "" {
                //Voir avec Firebase
                Auth.auth().signIn(withEmail: mail, password: mdp, completion: { (user, error) in
                    if let erreur = error {
                        let nsErreur = erreur as NSError
                        if nsErreur.code == 17011 {
                            Auth.auth().createUser(withEmail: mail, password: mdp, completion: { (user, error) in
                                if let erreur = error {
                                    Alerte().erreurSimple(controller: self, message: erreur.localizedDescription)
                                }
                                if user != nil {
                                    //Transition vers UsernameVue
                                    self.transition(vers: self.pseudoVue, transition: .transitionFlipFromRight)
                                }
                            })
                        } else {
                            Alerte().erreurSimple(controller: self, message: erreur.localizedDescription)
                        }
                    }
                    
                    if let id = user?.uid {
                        //Verifier si utilisateur existe
                        self.verifierUtilisateur(id: id)
                    }
                })
            } else {
                Alerte().erreurSimple(controller: self, message: "Le mot de passe ne peut pas être vide")
            }
        } else {
            Alerte().erreurSimple(controller: self, message: "L'adresse mail ne peut pas être vide")
        }
    }
    
    func transition(vers: UIView, transition: UIViewAnimationOptions) {
        UIView.transition(from: vueActuelle, to: vers, duration: 1.5, options: transition) { (success) in
            self.vueActuelle = vers
        }
    }
    
    func verifierUtilisateur(id: String) {
        
        BDD().recupererUtilisateur(id: id) { (utilisateur) -> (Void) in
            if utilisateur != nil {
                MOI = utilisateur!
                self.versApp()
            } else {
                self.transition(vers: self.pseudoVue, transition: .transitionFlipFromRight)
            }
        }
    }
    
    func versApp() {
        //instancier tabbarcontroller
        let tab = MonTabBar()
        self.present(tab, animated: true, completion: nil)
    }

}
