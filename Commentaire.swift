//
//  Commentaire.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Commentaire {
    
    
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _utilisateur: Utilisateur!
    private var _texte: String!
    private var _date: Double!
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var utilisateur: Utilisateur { return _utilisateur }
    var texte: String { return _texte }
    var date: Double { return _date }
    
    init(ref: DatabaseReference, id: String, utilisateur: Utilisateur, dict: [String: AnyObject]) {
        self._ref = ref
        self._id = id
        self._utilisateur = utilisateur
        self._texte = dict["texte"] as? String ?? ""
        self._date = dict["date"] as? Double ?? 0
        
    }
}
