//
//  EffetController.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import CoreImage

class EffetController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var image: UIImage!
    
    var effets = ["CIPhotoEffectChrome",
                  "CIPhotoEffectFade",
                  "CIPhotoEffectInstant",
                  "CIPhotoEffectMono",
                  "CIPhotoEffectProcess",
                  "CIPhotoEffectTonal",
                  "CIPhotoEffectTransfer",
                  "CISepiaTone"]
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: IMAGE_CARRE_CELL, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: IMAGE_CARRE_CELL)
        
        let suivant = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(auSuivant))
        navigationItem.rightBarButtonItem = suivant

    }
    
    @objc func auSuivant() {
        let controller = FinaliserPostController()
        controller.image = imageView.image!
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            let context = CIContext(options: nil)
            let ciImage = CIImage(image: self.image)
            for filtre in self.effets {
                if let filtreChoisi = CIFilter(name: filtre) {
                    filtreChoisi.setDefaults()
                    filtreChoisi.setValue(ciImage, forKey: kCIInputImageKey)
                    let filtreData = filtreChoisi.value(forKey:kCIOutputImageKey) as! CIImage
                    if let cgImage = context.createCGImage(filtreData, from: filtreData.extent) {
                        let imageAvecFiltre = UIImage(cgImage: cgImage, scale: self.image.scale, orientation: self.image.imageOrientation)
                        DispatchQueue.main.async {
                            self.images.append(imageAvecFiltre)
                            self.collectionView.reloadData()
                        }
                        
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IMAGE_CARRE_CELL, for: indexPath) as! ImageCarreCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let taille = collectionView.frame.height / 2
        return CGSize(width: taille, height: taille)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        self.imageView.image = image
    }
 
}
