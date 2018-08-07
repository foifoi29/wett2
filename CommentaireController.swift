//
//  CommentaireController.swift
//  Wettly
//
//  Created by Nathan Levy on 07/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class CommentaireController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var tableViewCom: UITableView!
    
    @IBOutlet weak var boutonPublier: WettlyBouton!
    @IBOutlet weak var textView: TextViewCommentaires!
    @IBOutlet weak var zoneDeTexte: UIView!
    @IBOutlet weak var contrainteDuBas: NSLayoutConstraint!
    @IBOutlet weak var hauteurZoneDeText: NSLayoutConstraint!
    
    var post: Post!
    var commentaires = [Commentaire]()
    var constanteDorigine: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constanteDorigine = contrainteDuBas.constant
        tableViewCom.delegate = self
        tableViewCom.dataSource = self
        tableViewCom.tableFooterView = UIView()
        textView.delegate = self
        let comNib = UINib(nibName: COMMENTAIRE_TB, bundle: nil)
        tableViewCom.register(comNib, forCellReuseIdentifier: COMMENTAIRE_TB)
        NotificationCenter.default.addObserver(self, selector: #selector(clavierIn), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clavierOut), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rangerMonClavier)))
        observer()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
    }
    
    func observer() {
        BDD().recupererCommentaire(ref: post.ref) { (commentaire) -> (Void) in
            if commentaire != nil {
                if let index = self.commentaires.index(where: {$0.id == commentaire!.id}) {
                    self.commentaires[index] = commentaire!
                } else {
                    self.commentaires.append(commentaire!)
                }
                self.tableViewCom.reloadData()
            }
        }
    }
    
    func animate(constante: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            self.contrainteDuBas.constant = constante
        }
    }
    
    @objc func clavierIn(notification: Notification) {
        if let hauteurDuClavier = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            animate(constante: -hauteurDuClavier)
        }
    }
    
    @objc func clavierOut(notification: Notification) {
        animate(constante: constanteDorigine)
    }
    
    @objc func rangerMonClavier() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentaires.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: COMMENTAIRE_TB) as! CommentaireCell
        cell.miseEnPlace(commentaire: commentaires[indexPath.row])
        return cell
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var haut: CGFloat!
        let hauteur = textView.text.rect(largeur: textView.frame.width, font: UIFont.systemFont(ofSize: 14)).height
        if hauteur < 22 {
            haut = 50
        } else {
            haut = 32 + hauteur
        }
        UIView.animate(withDuration: 0.1) {
            self.hauteurZoneDeText.constant = haut
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commentaire = commentaires[indexPath.row]
        let texte = commentaire.texte + "\n" + commentaire.date.ilYA()
        let hauteur = texte.rect(largeur: tableView.frame.width - 16, font: UIFont.systemFont(ofSize: 16)).height
        return hauteur + 80
    }
    
    
    @IBAction func actionBouton(_ sender: Any) {
        let dict = [
            "date": Date().timeIntervalSince1970 as AnyObject,
            "texte": textView.text as AnyObject,
            "utlisateur": MOI.id as AnyObject]
        textView.text = ""
        rangerMonClavier()
        BDD().envoyerCommentaire(ref: post.ref, dict: dict as [String: AnyObject])
    }
}
