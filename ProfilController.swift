//
//  ProfilController.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit


class ProfilController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var utilisateur: Utilisateur?
    var posts = [Post]()
    var postComplet = true

    override func viewDidLoad() {
        super.viewDidLoad()
        let nibImageCarre = UINib(nibName: IMAGE_CARRE_CELL, bundle: nil)
        let reusableView = UINib(nibName: PROFIL_HEADER, bundle: nil)
        collectionView!.delegate = self
        collectionView?.backgroundColor = UIColor(r: 96, g: 96, b: 96)
        collectionView!.register(PostCell.self, forCellWithReuseIdentifier: POST_CELL)
        collectionView!.register(nibImageCarre, forCellWithReuseIdentifier: IMAGE_CARRE_CELL)
        collectionView!.register(reusableView, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: PROFIL_HEADER)
        
        telechargerPosts()
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView?.reloadData()
    }
    
    func telechargerPosts() {
        var idAParser: String
        
        if utilisateur != nil {
            title = utilisateur!.pseudo
            idAParser = utilisateur!.id
        } else {
            title = MOI.pseudo
            idAParser = MOI.id
        }
        
        BDD().recupererPost(utilisateur: idAParser) { (post) -> (Void) in
            if post != nil {
                if let postExiste = self.posts.index(where: {$0.id == post!.id}) {
                    self.posts[postExiste] = post!
                } else {
                    self.posts.append(post!)
                }
                self.trierEtReload()
            }
        }
    }
    
    func trierEtReload() {
        self.posts = self.posts.sorted(by: {$0.date > $1.date})
        self.collectionView?.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if postComplet {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: POST_CELL, for: indexPath) as! PostCell
            cell.miseEnPlace(fil: nil, profil: self, post: posts[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMAGE_CARRE_CELL, for: indexPath) as! ImageCarreCell
            cell.imageView.telecharger(imageUrl: posts[indexPath.row].imageUrl)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if postComplet {
            let largeur = collectionView.frame.width
            let texteComplet = posts[indexPath.row].texte + "\n" + posts[indexPath.row].date.ilYA()
            let hauteurDuTexte = texteComplet.rect(largeur: largeur - 20, font: UIFont.systemFont(ofSize: 18)).height
            let hauteur = 200 + largeur + hauteurDuTexte
            return CGSize(width: largeur, height: hauteur)
        } else {
            let taille = collectionView.frame.width / 4
            return CGSize(width: taille, height: taille)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let desc = utilisateur?.desc ?? MOI.desc
        let hauteurDuDesc = desc.rect(largeur: collectionView.frame.width - 40, font: UIFont.systemFont(ofSize: 18)).height
        let hauteur = 320 + hauteurDuDesc
        return CGSize(width: collectionView.frame.width, height: hauteur)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: PROFIL_HEADER, for: indexPath) as! ProfilHeader
        header.miseEnPlace(controller: self, utilisateur: utilisateur ?? MOI)
        return header
    }
    

    
}
