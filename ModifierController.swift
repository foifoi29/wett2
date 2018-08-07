//
//  ModifierController.swift
//  Wettly
//
//  Created by Nathan Levy on 03/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class ModifierController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagedeFond: UIImageView!
    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var erreurPseudo: UILabel!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var validerBouton: WettlyBouton!

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var largeurFond: NSLayoutConstraint!
    var peutCreerPseudo = false
    var picker: UIImagePickerController?
    var hauteurDeScroll: CGFloat?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        largeurFond.constant = view.frame.width
        hauteurDeScroll = validerBouton.frame.maxY + 100
        scrollView.contentSize = CGSize(width: view.frame.width, height: hauteurDeScroll!)
        scrollView.layoutIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = UIImagePickerController()
        picker?.allowsEditing = true
        picker?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(clavierIn), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clavierOut), name: Notification.Name.UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rentrer)))
        imagedeFond.telecharger(imageUrl: MOI.imageUrl)
        imageDeProfil.telecharger(imageUrl: MOI.imageUrl)
        imageDeProfil.isUserInteractionEnabled = true
        imageDeProfil.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(prendrePhoto)))
        pseudoTextField.text = MOI.pseudo
        pseudoTextField.addTarget(self, action: #selector(texteMisAJour(_:)), for: .editingChanged)
        if MOI.prenom == "" {
            prenomTextField.placeholder = "Entrez votre prénom"
        } else {
            prenomTextField.text = MOI.prenom
        }
        
        if MOI.nom == "" {
            nomTextField.placeholder = "Entrez votre nom"
        } else {
            nomTextField.text = MOI.nom
        }
        
        descTextView.text = MOI.desc

        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var monImage: UIImage?
        if let modifiee = info[UIImagePickerControllerEditedImage] as? UIImage {
            monImage = modifiee
        } else if let originale = info[UIImagePickerControllerOriginalImage] as? UIImage {
            monImage = originale
        }
        self.picker?.dismiss(animated: true, completion: nil)
        guard monImage != nil, let data = UIImageJPEGRepresentation(monImage!, 0.2) else { return }
        view.creerActivityIndicator()
        Stockage().ajouterPostImage(reference: Ref().monProfilImage, data: data) { (success, urlString) -> (Void) in
            self.view.supprimmerActivityIndicator()
            guard let resultat = success, resultat == true, urlString != nil else { return }
            BDD().miseAJourUtilisateur(dict: ["imageUrl": urlString! as AnyObject], completion: { (utilisateur) -> (Void) in
                if utilisateur != nil {
                    MOI = utilisateur!
                    self.imagedeFond.telecharger(imageUrl: MOI.imageUrl)
                    self.imageDeProfil.telecharger(imageUrl: MOI.imageUrl)
                    
                }
            })
        }
    }
    
    @objc func prendrePhoto() {
        Alerte().camera(controller: self, picker: picker!)
    }

    @IBAction func actionValider(_ sender: Any) {
        view.endEditing(true)
        var dict = [String: AnyObject]()
        if prenomTextField.text != nil {
            dict["prenom"] = prenomTextField.text! as AnyObject
        }
        if nomTextField.text != nil {
            dict["nom"] = nomTextField.text! as AnyObject
        }
        if pseudoTextField.text != nil, peutCreerPseudo == true {
            dict["pseudo"] = pseudoTextField.text! as AnyObject
        }
        if descTextView.text != ""{
            dict["desc"] = descTextView.text as AnyObject
        }
        
        BDD().miseAJourUtilisateur(dict: dict) { (utilisateur) -> (Void) in
            if utilisateur != nil {
                MOI = utilisateur!
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc func rentrer() {
        view.endEditing(true)
    }
    
    @objc func clavierIn(notification: Notification) {
        if let clavierHauteur = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! NSValue?)?.cgRectValue.height, hauteurDeScroll != nil {
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.hauteurDeScroll! + clavierHauteur)
            }
           
        }
    }
    
    @objc func clavierOut(notification: Notification) {
        if hauteurDeScroll != nil {
            UIView.animate(withDuration: 0.5) {
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.hauteurDeScroll!)
            }
        }
    }
    
    @objc func texteMisAJour(_ textField: UITextField) {
        guard let nouveauPseudo = textField.text else { return }
        if nouveauPseudo == "" {
            peutCreerPseudo = false
            erreurPseudo.text = "Le nom d'utilisateur ne peut pas être vide"
        } else if nouveauPseudo.contains(" ") {
            peutCreerPseudo = false
            erreurPseudo.text = "Le nom d'utilisateur ne peut pas contenir d'espace"
        } else if nouveauPseudo.count >= 20 {
            peutCreerPseudo = false
            erreurPseudo.text = "Le pseudo est trop long"
        } else {
            BDD().pseudoExists(pseudo: nouveauPseudo) { (success, error) -> (Void) in
                guard success != nil, error != nil else { return }
                self.peutCreerPseudo = success!
                self.erreurPseudo.text = error!
            }
        }
    }
    
 
}
