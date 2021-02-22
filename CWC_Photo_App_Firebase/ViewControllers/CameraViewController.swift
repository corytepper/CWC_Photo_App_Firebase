//
//  CameraViewController.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/16/21.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet var progressLabel: UILabel!
    
    @IBOutlet var progressBar: UIProgressView!
    
    @IBOutlet var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        progressBar.alpha = 0
        progressBar.progress = 0
        
        doneButton.alpha = 0
        
        progressLabel.alpha = 0
        
        
        
    }
    
    
    func savePhoto(image:UIImage) {
        
        // Call the photo service to store the photo
        PhotoService.savePhoto(image: image) { (pct) in
            
            DispatchQueue.main.async {
                
                // Update the progress bar
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(pct)
                
                // Update the label
                let roundedPct = Int(pct * 100)
                self.progressLabel.text = "\(roundedPct) %"
                self.progressLabel.alpha = 1
                
                
                // Check if it's done
                if roundedPct == 100 {
                    self.doneButton.alpha = 1
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func doneTapped(_ sender: Any) {
        
        // Get a reference to the tab bar controller
        let tabBarVC = self.tabBarController as? MainTabBarController
        
        if let tabBarVC = tabBarVC {
            
            // Call go to feed
            tabBarVC.goToFeed()
       
            
        }
    }
    
}
