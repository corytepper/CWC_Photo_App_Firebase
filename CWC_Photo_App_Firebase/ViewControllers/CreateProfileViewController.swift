//
//  CreateProfileViewController.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/16/21.
//

import UIKit
import FirebaseAuth

class CreateProfileViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func confirmTapped(_ sender: Any) {
        
        // Check that there is a user logged in
        guard Auth.auth().currentUser != nil else {
            
            // No user logged in
            return
        }
        
        // Get the username
        // Check it against whitespaces, new lines, illegal character etc
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check that the username isn't nil
        if username == nil || username == "" {
            
            // Show an error message
            return
        }
        
        // Call the user service to create the profile
        UserService.createProfile(userId: Auth.auth().currentUser!.uid, username: username!) { (user) in
            
            // Check if it was created succesfully
            if user != nil {
                // If so, go to tab bar controller
                
                // Save the user to local storage
                LocalStorageService.saveUser(userId: user!.userId, username: user!.username)
                
                let tabBarVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboards.tabBarController)
                
                self.view.window?.rootViewController = tabBarVC
                self.view.window?.makeKeyAndVisible()
                
            } else {
                // If not, display error
            }
        }
    }
    

}
