//
//  Stockage.swift
//  Wettly
//
//  Created by Nathan Levy on 31/07/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import FirebaseStorage

class Stockage {
    
    func ajouterPostImage(reference: StorageReference, data: Data, completion: SuccesCompletion?) {
    
        reference.putData(data, metadata: nil) { (meta, error) in
            if error == nil {
                if let urlString = meta?.downloadURL()?.absoluteString {
                    completion?(true, urlString)
                } else {
                    completion?(false, nil)
                }
            } else {
                completion?(false, error!.localizedDescription)
            }
        }
    }
    
    
    
}



