//
//  PostVue.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class PostVue: UIView {
    
    @IBOutlet weak var imageDeProfil: ImageArrondie!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageDuPost: UIImageView!
    @IBOutlet weak var nombreLike: UILabel!
    @IBOutlet weak var boutonLike: UIButton!
    @IBOutlet weak var nombreCommentaires: UILabel!
    @IBOutlet weak var boutonCommentaire: UIButton!
    @IBOutlet weak var nombrePartage: UILabel!
    @IBOutlet weak var boutonPartage: UIButton!
    @IBOutlet weak var textView: TextViewAvecHashtag!
    
    

    var vue: UIView!
    var post: Post!
    var filController: FilController?
    var profilController: ProfilController?
    //var postUniqueController: PostUniqueController?
    var imageVueCoeur: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        vue = chargerXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        vue = chargerXib()
    }
    
    func miseEnPlace(post: Post, filController: FilController?, profilController: ProfilController?) {
        self.post = post
        self.filController = filController
        self.profilController = profilController
        //Télécharger les images (profil + post)
        imageDeProfil.telecharger(imageUrl: self.post.utilisateur.imageUrl)
        imageDuPost.telecharger(imageUrl: self.post.imageUrl)
        //Ajout UsenameLabel
        usernameLabel.attributedText = usernameEtNom()
        //Ajout likes et commentaires en Int (partage)
        nombreLike.text = String(self.post.likes.count)
        nombreCommentaires.text = String(self.post.commentaires.count)
        observerNouveauCommentaire()
        //Mettre en place bouton Like si j'aime ou pas le post
        if self.post.likes.contains(MOI.id) {
            boutonLike.setImage(#imageLiteral(resourceName: "coeurs-plein-50"), for: .normal)
        } else {
            boutonLike.setImage(#imageLiteral(resourceName: "coeurs-50"), for: .normal)
        }
        //Mettre en place customTextView avec les hashtags clickable
        textView.ajoutDuText(texte: self.post.texte, date: self.post.date)
        
        
        //Ajouter like si double tap sur notre image d profil
        imageDuPost.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImage))
        tap.numberOfTapsRequired = 2
        imageDuPost.addGestureRecognizer(tap)
        //Envoyer vers profil si tap profil ou usernameLabel
        imageDeProfil.isUserInteractionEnabled = true
        usernameLabel.isUserInteractionEnabled = true
        imageDeProfil.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(envoyerVersProfil)))
        usernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(envoyerVersProfil)))
    }
    
    func observerNouveauCommentaire() {
        var comms = [Commentaire]()
        BDD().recupererCommentaire(ref: self.post.ref) { (commentaire) -> (Void) in
            if let comm = commentaire {
                if let index = comms.index(where: {$0.id == comm.id}) {
                    comms[index] = comm
                } else {
                    comms.append(comm)
                }
                self.nombreCommentaires.text = String(self.post.commentaires.count)
            }
        }
    }
    
    @objc func envoyerVersProfil() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let controller = ProfilController(collectionViewLayout: layout)
        controller.utilisateur = self.post.utilisateur
        if filController != nil {
            filController?.navigationController?.pushViewController(controller, animated: true)
        } else if profilController != nil {
            profilController?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func doubleTapImage() {
        var mesLikes = self.post.likes
        if !mesLikes.contains(MOI.id) {
            mesLikes.append(MOI.id)
        }
        ajoutLikeEtNotification(mesLikes: mesLikes)
        if imageVueCoeur == nil {
            imageVueCoeur = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width / 2, height: frame.width / 2))
            imageVueCoeur?.image = #imageLiteral(resourceName: "heart")
            imageVueCoeur?.center = imageDuPost.center
            imageDuPost.addSubview(imageVueCoeur!)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageVueCoeur?.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }) { (success) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.imageVueCoeur?.transform = CGAffineTransform.identity
                }, completion: { (success) in
                    self.imageVueCoeur?.removeFromSuperview()
                    self.imageVueCoeur = nil
                })
            }
            
          
        }
    }
    
    
    func usernameEtNom() -> NSMutableAttributedString {
        let mutable = NSMutableAttributedString(string: self.post.utilisateur.pseudo, attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)])
        let nomEtPrenomString = "\n" + self.post.utilisateur.prenom + " " + self.post.utilisateur.nom
        mutable.append(NSAttributedString(string: nomEtPrenomString, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 14)]))
        return mutable
    }
    
    func ajoutLikeEtNotification(mesLikes: [String]) {
        BDD().mettreAJourPost(postId: self.post.id, userId: self.post.utilisateur.id, dict: ["likes": mesLikes as AnyObject])
        BDD().recupererPostsHashtag(dict: [self.post.id: self.post.utilisateur.id]) { (post) -> (Void) in
            if post != nil {
                self.miseEnPlace(post: post!, filController: self.filController, profilController: self.profilController)
            }
        }
    }
    
    
    
    @IBAction func actionLike(_ sender: Any) {
        var mesLikes = self.post.likes
        if boutonLike.imageView?.image == #imageLiteral(resourceName: "coeurs-50") {
            mesLikes.append(MOI.id)
        } else {
            if let index = mesLikes.index(of: MOI.id) {
                mesLikes.remove(at: index)
            }
        }
        ajoutLikeEtNotification(mesLikes: mesLikes)
    }
    
    @IBAction func actionCommentaire(_ sender: Any) {
        let controller = CommentaireController()
        controller.commentaires = self.post.commentaires
        controller.post = self.post
        if filController != nil {
            filController?.navigationController?.pushViewController(controller, animated: true)
        } else if profilController != nil {
            profilController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func actionPartage(_ sender: Any) {
    }
    
    
}
