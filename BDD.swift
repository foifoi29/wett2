//
//  BDD.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class BDD {
    
    func recupererUtilisateur(id: String, completion: UtilisateurCompletion?) {
        Ref().utilisateurSpecifique(id: id).observe(.value) { (snapshot) in
            if snapshot.exists(), let _ = snapshot.value as? [String: AnyObject] {
                completion?(Utilisateur(snapshot: snapshot))
            } else {
                completion?(nil)
            }
        }
    }
    
    func recupererTousLesUtilisateurs(completion: UtilisateurCompletion?) {
        Ref().racineUtilisateur.observe(.childAdded) { (snapshot) in
            completion?(Utilisateur(snapshot: snapshot))
        }
    }
    
    func pseudoExists(pseudo: String, completion: SuccesCompletion?) {
        Ref().racineUtilisateur.queryOrdered(byChild: "pseudo").queryEqual(toValue: pseudo).observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                completion?(true, "")
            } else {
                completion?(false, "Le pseudo est déjà pris!")
            }
        }
    }
    
    func miseAJourUtilisateur(dict: [String: AnyObject], completion: UtilisateurCompletion?) {
        guard let id = Auth.auth().currentUser?.uid else { completion?(nil); return }
        Ref().utilisateurSpecifique(id: id).updateChildValues(dict) { (error, ref) in
            if error == nil {
                self.recupererUtilisateur(id: id, completion: { (utilisateur) -> (Void) in
                    completion?(utilisateur)
                })
            }
        }
    }
    
    func mettreAJourPost(postId: String, userId: String, dict: [String: AnyObject]) {
        Ref().postSpecifique(key: postId, value: userId).updateChildValues(dict)
    }
    
    func creerPost(dict: [String: AnyObject]) {
        Ref().mesPostsBDD.childByAutoId().updateChildValues(dict) { (error, ref) in
            guard error == nil, let postId = ref.description().components(separatedBy: "/").last else { return }
            guard let string = dict["texte"] as? String else { return }
            let mots = string.components(separatedBy: " ")
            for mot in mots {
                if mot.hasPrefix("#") {
                    self.ajouterHashtag(postId: postId, mot: mot)
                }
            }
        }
    }
    
    func envoyerCommentaire(ref: DatabaseReference, dict: [String: AnyObject]) {
        Ref().commentaireDepuisRef(ref: ref).childByAutoId().updateChildValues(dict)
    }
    
    func recupererCommentaire(ref: DatabaseReference, completion: CommentaireCompletion?) {
        Ref().commentaireDepuisRef(ref: ref).observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                if let utilisateurId = dict["utilisateur"] as? String {
                    self.recupererUtilisateur(id: utilisateurId, completion: { (utilisateur) -> (Void) in
                        if utilisateur != nil {
                            let nouveauCommentaire = Commentaire(ref: snapshot.ref, id: snapshot.key, utilisateur: utilisateur!, dict: dict)
                            completion?(nouveauCommentaire)
                        } else {
                            completion?(nil)
                        }
                    })
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    func recupererHashtags(completion: HashtagCompletion?) {
        Ref().racineHashtag.observe(.childAdded) { (snapshot) in
            if let dict = snapshot.value as? [String: String] {
                let nomDecode = snapshot.key.decodage()
                let nouveauHashtag = Hashtag(nom: nomDecode, posts: dict)
                completion?(nouveauHashtag)
            }
        }
        
    }
    
    func ajouterHashtag(postId: String, mot: String) {
        Ref().hashtagSpecifique(hashtag: mot.codage()).updateChildValues([postId : MOI.id])
    }
    
    func recupererPost(utilisateur: String, completion: PostCompletion?) {
        recupererUtilisateur(id: utilisateur) { (util) -> (Void) in
            if util != nil {
                Ref().postUtilisateurSpecifique(id: utilisateur).observe(.childAdded, with: { (snapshot) in
                    completion?(self.convertirPost(utilisateur: util!, snapshot: snapshot))
                })
            }
        }
    }
    
    func convertirPost(utilisateur: Utilisateur, snapshot: DataSnapshot) -> Post? {
        let postId = snapshot.key
        if let dict = snapshot.value as? [String: AnyObject] {
            return Post(ref: snapshot.ref, id: postId, utilisateur: utilisateur, commentaires: [], dict: dict)
            
        } else {
            return nil
        }
    }
        
    
    
    func recupererPostsHashtag(dict: [String: String], completion: PostCompletion?) {
        for (key, value) in dict {
            recupererUtilisateur(id: value) { (util) -> (Void) in
                if let utilisateur = util {
                    Ref().postSpecifique(key: key, value: value).observe(.value) { (snapshot) in
                       completion?(self.convertirPost(utilisateur: utilisateur, snapshot: snapshot))
                    }
                } else {
                    completion?(nil)
                }
            }
           
        }
    }
    
    
    
}
