//
//  LibrairieCell.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import Photos

let LIBRAIRIE_CELL = "LibrairieCell"

class LibrairieCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    
    var controller: PhotoController?
    var images = [UIImage]()
    var assets = [PHAsset]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func miseEnPlace(controller: PhotoController) {
        self.controller = controller
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: IMAGE_CARRE_CELL, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: IMAGE_CARRE_CELL)
        recupererPhotos()
        let statut = PHPhotoLibrary.authorizationStatus()
        if statut == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    self.recupererPhotos()
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
        let taille = frame.size.width / 4
        return CGSize(width: taille, height: taille)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func fetchOptions() -> PHFetchOptions {
        let fetchOption = PHFetchOptions()
        fetchOption.fetchLimit = 50
        let trieur = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOption.sortDescriptors = [trieur]
        return fetchOption
    }
    
    func recupererPhotos() {
        let tousMesAssets = PHAsset.fetchAssets(with: .image, options: fetchOptions())
        DispatchQueue.global(qos: .background).async {
            tousMesAssets.enumerateObjects({ (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let taille = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: taille, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let monImage = image {
                        self.images.append(monImage)
                        self.assets.append(asset)
                    }
                    
                    if count == tousMesAssets.count - 1 {
                        DispatchQueue.main.async {
                            if self.images.count > 0 {
                                self.recuperperImage(image: self.images[0])
                            }
                            self.collectionView.reloadData()
                        }
                    }
                })
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        recuperperImage(image: images[indexPath.row])
    }
    
    func recuperperImage(image: UIImage) {
        imageView.image = image
        controller?.imageChoisie = image
        if let imageChoisie = images.index(of: image) {
            let assetChoisi = assets[imageChoisie]
            let options = PHImageRequestOptions()
            options.isSynchronous = false
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .opportunistic
            options.version = .current
            options.resizeMode = .exact
            options.progressHandler = {(progress, error, stop, info) in
            }
            PHCachingImageManager().requestImageData(for: assetChoisi, options: options) { (data, string, orientation, info) in
                if let imageData = data, let nouvelleImage = UIImage(data: imageData) {
                    self.imageView.image = nouvelleImage
                    self.controller?.imageChoisie = nouvelleImage
                }
            }
            
        }
    }
    

}
