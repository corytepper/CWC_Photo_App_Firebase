//
//  CameraViewController.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/16/21.
//

import UIKit

class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func savePhoto(image:UIImage) {
        
        // Call the photo service to store the photo
        PhotoService.savePhoto(image: image)
        
    }
    
    
}
