//
//  FinaliserPostController.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class FinaliserPostController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var imageDuPost: UIImageView!
    @IBOutlet weak var textView: UITextView!
    
    var image: UIImage!
    var peutAjouter = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clavier()
        imageDuPost.image = image
        textView.delegate = self
        let suivant = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(finaliserPost))
        navigationItem.rightBarButtonItem = suivant

    }
    
    @objc func finaliserPost() {
        self.view.endEditing(true)
        if peutAjouter {
            peutAjouter = false
            verifierTextView()
            //enregistrer l'image dans le stockage -> URL string
            guard let data = UIImageJPEGRepresentation(image, 0.5) else { return }
            view.creerActivityIndicator()
            let idUnique = UUID().uuidString
            Stockage().ajouterPostImage(reference: Ref().mesPostsImage.child(idUnique) ,data: data) { (success, string) -> (Void) in
                self.peutAjouter = true
                self.view.supprimmerActivityIndicator()
                if let reussite = success, reussite == true, string != nil {
                    let dict: [String: AnyObject] = [
                        "imageUrl": string! as AnyObject,
                        "id": MOI.id as AnyObject,
                        "texte": self.textView.text as AnyObject,
                        "date": Date().timeIntervalSince1970 as AnyObject
                    ]
                    BDD().creerPost(dict: dict)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func verifierTextView() {
        if textView.text == "Ecrire une légende..." {
            textView.text = ""
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       verifierTextView()
    }
}
