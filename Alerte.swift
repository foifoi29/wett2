//
//  Alerte.swift
//  Wettly
//
//  Created by Nathan Levy on 24/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import FirebaseAuth

class Alerte {
    
    func erreurSimple(controller: UIViewController, message: String) {
        let alerte = UIAlertController(title: "Erreur", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alerte.addAction(ok)
        controller.present(alerte, animated: true, completion: nil)
    }
    
    func camera(controller: UIViewController, picker: UIImagePickerController) {
        let alerte = UIAlertController(title: "Choisir une photo", message: nil, preferredStyle: .alert)
        let appareil = UIAlertAction(title: "Appareil photo", style: .default) { (action) in
            picker.sourceType = .camera
            controller.present(picker, animated: true, completion: nil)
        }
        let librairie = UIAlertAction(title: "Librairie de photo", style: .default) { (action) in
            picker.sourceType = .photoLibrary
            controller.present(picker, animated: true, completion: nil)
        }
        let annuler = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alerte.addAction(appareil)
        alerte.addAction(librairie)
        alerte.addAction(annuler)
        controller.present(alerte, animated: true, completion: nil)
        
    }
    
    func deconnection(controller: UIViewController) {
        let alerte = UIAlertController(title: "Êtes-vous sûr de vouloir vous déconnecter ?", message: nil, preferredStyle: .actionSheet)
        let deconnexion = UIAlertAction(title: "Déconnexion", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut()
            } catch {
               print(error.localizedDescription)
            }
            controller.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        let annuler = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        alerte.addAction(deconnexion)
        alerte.addAction(annuler)
        controller.present(alerte, animated: true, completion: nil)
    }
    
}
