//
//  PhotoService.swift
//  CWC_Photo_App_Firebase
//
//  Created by Cory Tepper on 2/18/21.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PhotoService {
    
    
    static func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
                
        // Get a database reference
        let db = Firestore.firestore()
        
        // Get all the documents form the photos collection
        db.collection("photos").getDocuments { (snapshot, error) in
            
            // Check for errors
            if error != nil {
                
                // Error in retrieving photos
                return
            }
            
            // Get all the documents
            let documents = snapshot?.documents
            
            // Check that documents aren't nil
            if let documents = documents {
                
                // Create an array to hold all of our Photo structs
                var photoArray = [Photo]()
            
                // Loop through the documents, create a photo struct for each
                for doc in documents {
                    
                    // Create photo struct
                    let p = Photo(snapshot: doc)
                    
                    if p != nil {
                        // Store it in our array
                        photoArray.insert(p!, at: 0)
                    }
                }
                
                // Pass back the photo array
                completion(photoArray)
            }

        }
        
        
    }
    
    static func savePhoto(image:UIImage, progressUpdate: @escaping (Double) -> Void ) {
        
        // Check that there's a user logged in
        if Auth.auth().currentUser == nil {
            return
        }
        
        // Get the data representation of the UIImage
        let photoData = image.jpegData(compressionQuality: 0.1)
        
        guard photoData != nil else {
            // Error, couldn't get the data from the UIImage
            return
        }
        // Create a filename
        let filename = UUID().uuidString

        // Get the user id of the current user
        let userId = Auth.auth().currentUser!.uid
        
        // Create a firebase storage path/referencer
        let ref = Storage.storage().reference().child("images/\(userId)/\(filename).jpg")
        
        // Upload the data
        let uploadTask = ref.putData(photoData!, metadata: nil) { (metadata, error) in
            
            // Check if upload was successful
            if error == nil {
                // Upon successful upload, create the database entry
                self.createDatabaseEntry(ref: ref)
            }
            
        }
        
        uploadTask.observe(.progress) { (taskSnapshot) in
            
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            
            print(pct)
            
            progressUpdate(pct)
            
        }
        
        
    }
    
    
    private static func createDatabaseEntry(ref: StorageReference) {
        
        
        // Download url
        ref.downloadURL { (url, error) in
            
            // If there's no error, then proceed
            if error == nil {
                
                // Photo id
                let photoId = ref.fullPath
                
                // User id
                let photoUser = LocalStorageService.loadUser()
                
                let userId = photoUser?.userId
                
                // Username
                let username = photoUser?.username
                
                // Date
                let df = DateFormatter()
                df.dateStyle = .full
                
                let dateString = df.string(from: Date())
                
                // Create a dictionary of the photo metadata
                let metadata = ["photoId":photoId, "byId":userId!, "byUserName":username!, "date":dateString, "url":url!.absoluteString ]
                
                
                // Save the metadata to the firestroe database
                let db = Firestore.firestore()
                
                db.collection("photos").addDocument(data: metadata) { (error) in
                    
                    // Check if the saving of the data was successful
                    if error == nil {
                        // Successfully created database entry for the photo
                    }
                   
                }
           }
            
        }
        
    }
    
}
