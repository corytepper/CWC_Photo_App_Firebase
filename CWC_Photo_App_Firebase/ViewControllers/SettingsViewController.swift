//
//  SettingsViewController.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/16/21.
//

import UIKit
import FirebaseAuth

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutTapped(_ sender: Any) {
        
        
        do {
            // Try to sign out the user
            try Auth.auth().signOut()
        
        
            // Clear local storage
            LocalStorageService.clearUser()
        
            // Transition to authentication flow
            let loginNavVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboards.loginNavController)
            
            self.view.window?.rootViewController = loginNavVC
            self.view.window?.makeKeyAndVisible()
        }
        catch {
            // Couldn't sign out the user
        }
        
    }
    

}
