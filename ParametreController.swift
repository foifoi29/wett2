//
//  ParamètreController.swift
//  Wettly
//
//  Created by Nathan Levy on 03/08/2018.
//  Copyright © 2018 NTH. All rights reserved.
//

import UIKit
import FirebaseAuth

class ParametreController: UIViewController {
    
    @IBOutlet weak var parametreBouton: WettlyBouton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actionSeDeconnecter(_ sender: Any) {
        Alerte().deconnection(controller: self)
    }
    

}
