//
//  RechercheController.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class RechercheController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var utilisateurs = [Utilisateur]()
    var utilisateursFiltres = [Utilisateur]()
    var hashtags = [Hashtag]()
    var hashtagsFiltres = [Hashtag]()
    var enRecherche = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        let utilisateurNib = UINib(nibName: UTILISATEUR_TB, bundle: nil)
        tableView.register(utilisateurNib, forCellReuseIdentifier: UTILISATEUR_TB)
        
        let hashNib = UINib(nibName: HASHTAG_TB, bundle: nil)
        tableView.register(hashNib, forCellReuseIdentifier: HASHTAG_TB)
        
        tableView.tableFooterView = UIView()
        
        recupererHashtagsDeLaBaseDeDonnee()
        recupererUtilisateurBaseDeDonnee()

    }
    
    func recupererUtilisateurBaseDeDonnee() {
        BDD().recupererTousLesUtilisateurs { (util) -> (Void) in
            if let utilisateur = util {
                if let index = self.utilisateurs.index(where: {$0.id == utilisateur.id}) {
                    self.utilisateurs[index] = utilisateur
                } else {
                    self.utilisateurs.append(utilisateur)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func recupererHashtagsDeLaBaseDeDonnee() {
        BDD().recupererHashtags { (hash) -> (Void) in
            if let hashtag = hash {
                self.hashtags.append(hashtag)
                self.tableView.reloadData()
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            if enRecherche {
                return utilisateursFiltres.count
            } else {
                return utilisateurs.count
            }
            
        } else {
            if enRecherche {
                return hashtagsFiltres.count
            } else {
                return hashtags.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: UTILISATEUR_TB) as! UtilisateurCell
            if enRecherche {
                cell.miseEnPlace(utilisateur: utilisateursFiltres[indexPath.row])
            } else {
                cell.miseEnPlace(utilisateur: utilisateurs[indexPath.row])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HASHTAG_TB) as! HashtagCell
            if enRecherche {
                cell.miseEnPlace(hashtag: hashtagsFiltres[indexPath.row])
            } else {
                cell.miseEnPlace(hashtag: hashtags[indexPath.row])
            }
            return cell
        }
    }
    
    @IBAction func segmentChoisi(_ sender: Any) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if segment.selectedSegmentIndex == 0 {
            return 80
        } else {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        if segment.selectedSegmentIndex == 0 {
            let controlleur = ProfilController(collectionViewLayout: layout)
            if enRecherche {
                controlleur.utilisateur = utilisateursFiltres[indexPath.row]
            } else {
                controlleur.utilisateur = utilisateurs[indexPath.row]
            }
            navigationController?.pushViewController(controlleur, animated: true)
        } else {
            let controlleur = FilController(collectionViewLayout: layout)
            if enRecherche {
                controlleur.hashtag = hashtagsFiltres[indexPath.row]
            } else {
                controlleur.hashtag = hashtags[indexPath.row]
            }
            navigationController?.pushViewController(controlleur, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            enRecherche = false
            view.endEditing(true)
        } else {
            enRecherche = true
            let minuscule = searchBar.text?.lowercased()
            if segment.selectedSegmentIndex == 0 {
                utilisateursFiltres = utilisateurs.filter {
                    return $0.pseudo.lowercased().range(of: minuscule!) != nil || $0.nom.lowercased().range(of: minuscule!) != nil || $0.prenom.lowercased().range(of: minuscule!) != nil
                }
            } else {
                hashtagsFiltres = hashtags.filter {
                    return $0.nom.lowercased().range(of: minuscule!) != nil
                }
            }
        }
        tableView.reloadData()
    }
    
    
}
