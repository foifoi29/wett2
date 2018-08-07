//
//  Ref.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Ref {
    let bdd = Database.database().reference()
    let stockage = Storage.storage().reference()
    
    //DATABASE
    
    var racineUtilisateur: DatabaseReference { return bdd.child("utilisateur")}
    var racinePost: DatabaseReference { return bdd.child("posts")}
    var racineHashtag: DatabaseReference { return bdd.child("hashtag")}
    
    var mesPostsBDD: DatabaseReference { return racinePost.child(MOI.id)}
    
    func utilisateurSpecifique(id: String) -> DatabaseReference {
        return racineUtilisateur.child(id)
    }
    
    func postUtilisateurSpecifique(id: String) -> DatabaseReference {
        return racinePost.child(id)
    }
    
    func postSpecifique(key: String, value: String) -> DatabaseReference {
        return postUtilisateurSpecifique(id: value).child(key)
    }
    
    func hashtagSpecifique(hashtag: String) -> DatabaseReference {
        return racineHashtag.child(hashtag)
    }
    
    func commentaireDepuisRef(ref: DatabaseReference) -> DatabaseReference {
        return ref.child("commentaires")
    }
    
    //STOCKAGE
    var racinePostImage: StorageReference { return stockage.child("posts")}
    var mesPostsImage: StorageReference { return racinePostImage.child(MOI.id)}
    var racineProfilImage: StorageReference { return stockage.child("profil")}
    var monProfilImage: StorageReference { return racineProfilImage.child(MOI.id)}
}
