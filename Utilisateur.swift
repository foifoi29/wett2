//
//  Utilisateur.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Utilisateur {
    private var _ref: DatabaseReference!
    private var _id: String!
    private var _pseudo: String!
    private var _prenom: String!
    private var _nom: String!
    private var _desc: String!
    private var _imageUrl: String!
    private var _abonnes: [String]!
    private var _abonnements: [String]!
    
    var ref: DatabaseReference { return _ref }
    var id: String { return _id }
    var pseudo: String { return _pseudo }
    var prenom: String { return _prenom }
    var nom: String { return _nom }
    var desc: String { return _desc }
    var imageUrl: String { return _imageUrl }
    var abonnes: [String] { return _abonnes }
    var abonnements: [String] { return _abonnements }
    
    init(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: AnyObject] else { return }
        self._ref = snapshot.ref
        self._id = snapshot.key
        self._pseudo = dict["pseudo"] as? String ?? ""
        self._prenom = dict["prenom"] as? String ?? ""
        self._nom = dict["nom"] as? String ?? ""
        self._desc = dict["desc"] as? String ?? ""
        self._imageUrl = dict["imageUrl"] as? String ?? ""
        self._abonnes = dict["abonnes"] as? [String] ?? []
        self._abonnements = dict["abonnements"] as? [String] ?? []
        
        
    }
        
    
    
}
