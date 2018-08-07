//
//  FilController.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit


class FilController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    var hashtag: Hashtag?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(r: 96, g: 96, b: 96)
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: POST_CELL)
        collectionView?.delegate = self
        if hashtag != nil {
            recupererHash()
            title = hashtag!.nom
        } else {
            recupererTousLesPosts()
        }
       
    }
    
    func trierEtReload() {
        self.posts = self.posts.sorted(by: {$0.date > $1.date})
        self.collectionView?.reloadData()
    }
    
    func recupererHash() {
        BDD().recupererPostsHashtag(dict: hashtag!.posts) { (post) -> (Void) in
            if post != nil {
                self.verifierSiPostExiste(post: post!)
            }
        }
    }
    
    func verifierSiPostExiste(post: Post) {
        if let index = self.posts.index(where: {$0.id == post.id}) {
            self.posts[index] = post
        } else {
            self.posts.append(post)
        }
        self.trierEtReload()
    }

    func recupererTousLesPosts() {
        var utilisateursAParser = MOI.abonnements
        utilisateursAParser.append(MOI.id)
        for utilisateur in utilisateursAParser {
            BDD().recupererPost(utilisateur: utilisateur, completion: { (post) -> (Void) in
                if post != nil {
                   self.verifierSiPostExiste(post: post!)
                }
            })
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return nos posts
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //creer une cell post
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: POST_CELL, for: indexPath) as! PostCell
        cell.miseEnPlace(fil: self, profil: nil, post: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = posts[indexPath.row]
        let largeur = collectionView.frame.width
        let texteComplet = posts[indexPath.row].texte //+ "\n" + posts[indexPath.row].date.ilYA()
        let hauteurDuTexte = texteComplet.rect(largeur: largeur - 20, font: UIFont.systemFont(ofSize: 18)).height
        var hauteur = 200 + largeur + hauteurDuTexte
        let texte = post.texte + "\n" + post.date.ilYA()
        hauteur += texte.rect(largeur: collectionView.frame.width, font: UIFont.systemFont(ofSize: 14)).height
        return CGSize(width: largeur, height: hauteur)
    }
    
    
    
    
    
}
