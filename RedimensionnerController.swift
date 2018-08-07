//
//  RedimensionnerController.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit

class RedimensionnerController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var fondImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var largeurContrainte: NSLayoutConstraint!
    @IBOutlet weak var hauteurContrainte: NSLayoutConstraint!
    
    var image: UIImage!
    var suivant: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        imageADecouper(image: image)
        suivant = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(auSuivant))
        navigationItem.rightBarButtonItem = suivant

    }
    
    func imageADecouper(image: UIImage) {
        fondImageView.image = image
        imageView.image = image
        largeurContrainte.constant = image.size.width
        hauteurContrainte.constant = image.size.height
        let echelleLargeur = scrollView.frame.size.width / image.size.width
        let echelleHauteur = scrollView.frame.size.height / image.size.height
        scrollView.minimumZoomScale = max(echelleLargeur, echelleHauteur)
        scrollView.zoomScale = max(echelleLargeur, echelleHauteur)
    }
    
    @objc func auSuivant() {
        let echelle = 1 / scrollView.zoomScale
        let x: CGFloat = scrollView.contentOffset.x * echelle
        let y: CGFloat = scrollView.contentOffset.y * echelle
        let largeur: CGFloat = scrollView.frame.size.width * echelle
        let hauteur: CGFloat = scrollView.frame.size.height * echelle
        let rect: CGRect = CGRect(x: x, y: y, width: largeur, height: hauteur)
        if let cgImageDecoupee = imageView.image?.cgImage?.cropping(to: rect) {
            let imageDecoupee = UIImage(cgImage: cgImageDecoupee, scale: image.scale, orientation: image.imageOrientation)
            let controller = EffetController()
            controller.image = imageDecoupee
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
