//
//  AppareilPhotoCell.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import AVFoundation

let CAMERA_CELL = "AppareilPhotoCell"

class AppareilPhotoCell: UICollectionViewCell, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var vueCamera: UIView!
    @IBOutlet weak var boutonFlash: UIButton!
    @IBOutlet weak var boutonRotation: UIButton!
    @IBOutlet weak var boutonPrendrePhoto: UIButton!
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureOutput: AVCapturePhotoOutput?
    var position = AVCaptureDevice.Position.front
    var reglages = AVCapturePhotoSettings()
    var flashStatus = FlashStatus.off
    var controller: PhotoController?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func miseEnPlaceAppareil(controller: PhotoController) {
        self.controller = controller
        self.boutonFlash.isHidden = true
        videoPreviewLayer?.removeFromSuperlayer()
        
        if let appareil = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) {
            if appareil.hasFlash {
                boutonFlash.isHidden = false
                flash()
            }
            
            do {
                let input = try AVCaptureDeviceInput(device: appareil)
                captureSession = AVCaptureSession()
                if (captureSession?.canAddInput(input))! {
                    captureSession?.addInput(input)
                }
                captureOutput = AVCapturePhotoOutput()
                if (captureSession?.canAddOutput(captureOutput!))! {
                    captureSession?.addOutput(captureOutput!)
                }
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = vueCamera.bounds
                vueCamera.layer.addSublayer(videoPreviewLayer!)
                captureSession?.startRunning()
                
            } catch {
                print("une erreur est survenue")
            }
        }
    }
    
    
    @IBAction func actionFlash(_ sender: Any) {
        switch flashStatus {
        case .on:
            flashStatus = .off
            boutonFlash.setImage(#imageLiteral(resourceName: "flash-désactivé-plein-50"), for: .normal)
        case .off:
            flashStatus = .on
            boutonFlash.setImage(#imageLiteral(resourceName: "flash-activé-plein-50"), for: .normal)
        }
        flash()
    }
    
    @IBAction func actionRotation(_ sender: Any) {
        if position == .front {
            position = .back
        } else {
            position = .front
        }
        miseEnPlaceAppareil(controller: controller!)
    }
    
    func flash() {
        switch flashStatus {
        case .on: reglages.flashMode = .on
        case .off: reglages.flashMode = .off
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else { return }
        //prendre notre image, l'envoyer au UIViewController suivant via PhotoController
        controller?.prendrePhotoEtSuivant(image: obtenirPhotoCarre(image: image ))
    }
    
    func obtenirPhotoCarre(image: UIImage) -> UIImage {
        if let layer = videoPreviewLayer {
            let rectOutput = layer.metadataOutputRectConverted(fromLayerRect: layer.bounds)
            var cgImage = image.cgImage!
            let x = rectOutput.origin.x * CGFloat(cgImage.width)
            let y = rectOutput.origin.y * CGFloat(cgImage.height)
            let width = rectOutput.size.width * CGFloat(cgImage.width)
            let height = rectOutput.size.height * CGFloat(cgImage.height)
            let rectACouper = CGRect(x: x, y: y, width: width, height: height)
            cgImage = cgImage.cropping(to: rectACouper)!
            let imageRect = UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
            return imageRect
        } else {
            return image
        }
    }
    
    @IBAction func actionPrendrePhoto(_ sender: Any) {
        captureOutput?.capturePhoto(with: reglages, delegate: self)
        miseEnPlaceAppareil(controller: controller!)
    }
    
    
    
    
    
}
