//
//  Post.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Post {
    
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _utilisateur: Utilisateur!
    private var _imageUrl: String!
    private var _texte: String!
    private var _date: Double!
    private var _likes: [String]!
    private var _commentaires: [Commentaire]!
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var utilisateur: Utilisateur { return _utilisateur }
    var imageUrl: String { return _imageUrl }
    var texte: String { return _texte }
    var date: Double { return _date }
    var likes: [String] { return _likes }
    var commentaires: [Commentaire] { return _commentaires }
    
    init(ref: DatabaseReference, id: String, utilisateur: Utilisateur, commentaires: [Commentaire], dict: [String: AnyObject]) {
        self._ref = ref
        self._id = id
        self._utilisateur = utilisateur
        self._commentaires = commentaires
        self._imageUrl = dict["imageUrl"] as? String ?? ""
        self._texte = dict["texte"] as? String ?? ""
        self._date = dict["date"] as? Double ?? 0
        self._likes = dict["likes"] as? NSArray as? [String] ?? []
        comms()
    }
    
    func comms() {
        BDD().recupererCommentaire(ref: self._ref) { (commentaire) -> (Void) in
            if commentaire != nil {
                self._commentaires.append(commentaire!)
            }
        }
    }
}
