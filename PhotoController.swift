//
//  PhotoController.swift
//  Wettly
//
//  Created by Nathan Levy on 30/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class PhotoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: SegmentedControll!
    
    var boutonSuivant: UIBarButtonItem?
    var imageChoisie: UIImage?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        let appareilNib = UINib(nibName: CAMERA_CELL, bundle: nil)
        let librairieNib = UINib(nibName: LIBRAIRIE_CELL, bundle: nil)
        collectionView.register(appareilNib, forCellWithReuseIdentifier: CAMERA_CELL)
        collectionView.register(librairieNib, forCellWithReuseIdentifier: LIBRAIRIE_CELL)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        montrerBoutonSuivant()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segment.numberOfSegments
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segment.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CAMERA_CELL, for: indexPath) as! AppareilPhotoCell
            cell.miseEnPlaceAppareil(controller: self)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LIBRAIRIE_CELL, for: indexPath) as! LibrairieCell
            cell.miseEnPlace(controller: self)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func prendrePhotoEtSuivant(image: UIImage) {
        let controller = EffetController()
        controller.image = image
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func montrerBoutonSuivant() {
        if segment.selectedSegmentIndex == 1 {
            boutonSuivant = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(auSuivant))
            navigationItem.rightBarButtonItem = boutonSuivant
        } else {
            if boutonSuivant != nil {
                boutonSuivant = nil
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    @objc func auSuivant() {
        if imageChoisie != nil {
            let nouveauController = RedimensionnerController()
            nouveauController.image = imageChoisie!
            navigationController?.pushViewController(nouveauController, animated: true)
        }
    }
    
    @IBAction func actionSegment(_ sender: Any) {
        let indexPath = IndexPath(item: segment.selectedSegmentIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
        montrerBoutonSuivant()
    }
    
}
