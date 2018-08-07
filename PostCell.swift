//
//  PostCell.swift
//  Wettly
//
//  Created by Nathan Levy on 01/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit


let POST_CELL = "PostCell"

class PostCell: UICollectionViewCell {
    
    var filController: FilController?
    var profilController: ProfilController?
    var post: Post!
    var postVue: PostVue?
    
    
    func miseEnPlace(fil: FilController?, profil: ProfilController?, post: Post) {
        self.filController = fil
        self.profilController = profil
        self.post = post
        if postVue == nil {
            postVue = PostVue(frame: bounds)
            addSubview(postVue!)
        }
        postVue?.frame = bounds
        postVue?.miseEnPlace(post: self.post, filController: self.filController, profilController: self.profilController)
        
        
    }
    
}
