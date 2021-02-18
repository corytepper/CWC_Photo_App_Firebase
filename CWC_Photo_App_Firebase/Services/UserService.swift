//
//  UserService.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/17/21.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func createProfile(userId:String, username:String, completetion: @escaping (PhotoUser?) -> Void ) {
        
        // Create a dictionary for the profile data
        let profileData = ["username":username]
        
        // Get a firestore reference
        let db = Firestore.firestore()
        
        // Create the document for the userid
        db.collection("users").document(userId).setData(profileData) { (error) in
            
            // Check for errors
            if error == nil {
                // Profile was create successfully
                // Create and return a photo user
                var u = PhotoUser()
                u.username = username
                u.userId = userId
                
                completetion(u)
                
            } else {
                // Something went wrong
                // Return nil
                completetion(nil)
            }
            
        }
        
    }
    
    static func retrieveProfile(userId:String, completetion: @escaping (PhotoUser?) -> Void ) {
     
        // Get a firstore reference
        let db = Firestore.firestore()

        // Check for a profile, given the user id
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            
            if error != nil || snapshot == nil {
                // Something wrong happened
                return
            }
  
            if let profile = snapshot!.data() {
                // Profile was found, create a new Photo user
                
                var u = PhotoUser()
                u.userId = snapshot!.documentID
                u.username = profile["username"] as? String
                
                // Return the user
                completetion(u)
                
            } else {
                // Couldn't get profile, no profile
                // Return nil
                completetion(nil)
            }
            
            
        }
        
        
        
    }
    
}
