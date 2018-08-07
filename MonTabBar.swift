//
//  MonTabBar.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class MonTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        UITabBar.appearance().barTintColor = UIColor(r: 96, g: 96, b: 96)
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
        
        let fil = FilController(collectionViewLayout: layout)
        let notif = NotificationController(style: .plain)
        let profil = ProfilController(collectionViewLayout: layout)

        viewControllers = [
        ajouter(controller: fil, unselectedImage: #imageLiteral(resourceName: "accueil-50.png"), selectedImage: #imageLiteral(resourceName: "accueil-plein-50.png"), titre: "accueil"),
        ajouter(controller: RechercheController(), unselectedImage: #imageLiteral(resourceName: "chercher-50.png"), selectedImage: #imageLiteral(resourceName: "chercher-plein-50.png"), titre: "recherche"),
        ajouter(controller: PhotoController(), unselectedImage: #imageLiteral(resourceName: "plus-50.png"), selectedImage: #imageLiteral(resourceName: "plus-plein-50.png"), titre: ""),
        ajouter(controller: notif, unselectedImage: #imageLiteral(resourceName: "notification-50.png"), selectedImage: #imageLiteral(resourceName: "notification-plein-50.png"), titre: "notification"),
        ajouter(controller: profil, unselectedImage: #imageLiteral(resourceName: "utilisateur-50.png"), selectedImage: #imageLiteral(resourceName: "utilisateur-plein-50.png"), titre: "profil")
        ]
    }
    
    func ajouter(controller: UIViewController, unselectedImage: UIImage, selectedImage: UIImage, titre: String) -> UINavigationController {
        let nav = MonNav(rootViewController: controller)
        //nav.tabBarItem.image = image
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = titre
        return nav
    }
    
}
