//
//  UserService.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserService {
    
    static let instance = UserService()
    
    // initialize the cloud firestore and storage buckets
    let db: Firestore = Firestore.firestore()
    let storage: Storage = Storage.storage()
    
    required init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    // store current user
    var currentUser: ProfileUser = ProfileUser()
    
    
    /*-- Get methods --*/
    func getCurrentUserDataFromCloudFirestore(completion: @escaping (Bool) -> ()) {
        if currentUser.id == nil {
            guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else {
                completion(false)
                return
            }
            
            let currentUserRef = db.collection(_USERS).document(userId)
            currentUserRef.addSnapshotListener { (document, error) in
                if error != nil {
                    completion(false)
                } else {
                    if let document = document, document.exists {
                        if let data = document.data() {
                            
                            // set regular data
                            self.currentUser.id = userId
                            self.currentUser.isLocationPermissionGranted = data["isLocationPermissionGranted"] as? Bool
                            self.currentUser.favouriteCategoryIds = data["favouriteCategoryIds"] as? [Int]
                            self.currentUser.friendsCount = data["friendsCount"] as? Int ?? 0
                            self.currentUser.friends = data["friends"] as? [String] ?? []
                            self.currentUser.followersCount = data["followersCount"] as? Int ?? 0
                            self.currentUser.followers = data["followers"] as? [String] ?? []
                            self.currentUser.followingCount = data["followingCount"] as? Int ?? 0
                            self.currentUser.following = data["following"] as? [String] ?? []
                            self.currentUser.notificationsCount = data["notificationsCount"] as? Int ?? 0
                            self.currentUser.unreadEventNotificationsCount = data["unreadNotificationsCount"] as? Int ?? 0
                            self.currentUser.eventsCount = data["events"] as? Int ?? 0
                            self.currentUser.unreadEventNotificationsCount = data["unreadEventNotificationsCount"] as? Int ?? 0
                            self.currentUser.hasNewDitlos = data["hasNewDitlos"] as? Bool ?? false
                            
                            // set the name data
                            if let firstName = data["firstName"] as? String,
                                let lastName = data["lastName"] as? String {
                                self.currentUser.name = "\(firstName) \(lastName)"
                            }
                            
                            // set the profile image data
                            do {
                                guard let profileImageUrlString = data["profileImageUrl"] as? String else {
                                    // give a locally stored default image
                                    print("1")
                                    return
                                }
                                do {
                                    let imageData = try Data(contentsOf: URL(string: profileImageUrlString)!)
                                    let profileImage = UIImage(data: imageData)
                                    self.currentUser.profileImage = profileImage
                                } catch {
                                    // give a locally stored default image
                                    print("2")
                                }
                            }
                            
                            completion(true)
                        }
                    } else {
                        completion(false)
                    }
                }
            }
        }
    }
    
    
    
    /*-- Set Methods --*/
    func storeCurrentUserData(atUserId userId: String, withName name: String, andEmailAddress emailAddress: String, completion: @escaping (Bool) -> ()) {
        db.collection(_USERS).document(userId).setData([
            "name": name,
            "emailAddress": emailAddress,
            "hasNewDitlos": false
        ]) { (error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func updateUserData<T>(withName name: String, andValue value: T, completion: @escaping (Bool) -> ()) {
        guard let userId = UserDefaults.standard.object(forKey: "userId") as? String else { completion(false); return }
        
        if name == "profileImageUrl" {
            storeProfileImageInStorageBucket(withUserId: userId, andProfileImage: value as! UIImage) { (storedSuccessfully, imageLocationString) in
                if storedSuccessfully {
                    print("image Location string stored successfully")
                    self.db.collection(_USERS).document(userId).setData([
                        name: imageLocationString!
                        ], merge: true, completion: { (error) in
                            if error != nil {
                                completion(false)
                            } else {
                                completion(true)
                            }
                    })
                } else {
                    // put a default in the store and route to that
                    print("Couldn't save image to storage")
                }
            }
        } else {
            db.collection(_USERS).document(userId).setData([
                name: value
            ], merge: true) { (error) in
                if error != nil {
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    
    func storeProfileImageInStorageBucket(withUserId userId: String, andProfileImage image: UIImage, completion: @escaping (_ storageSuccessful: Bool, _ storageLocationUrl: String?) -> ()) {
        guard let imageData = image.pngData() else { print("Failed to get representation"); completion(false, nil); return }
        let profileImageStorageRef = storage.reference().child("profile-images/").child("\(userId)_profileImage")
        profileImageStorageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                print("1. \(String(describing: error?.localizedDescription))")
                completion(false, nil)
            } else {
                profileImageStorageRef.downloadURL(completion: { (locationUrl, error) in
                    if error != nil {
                        print("2. \(String(describing: error?.localizedDescription))")
                        completion(false, nil)
                    } else {
                        completion(true, locationUrl?.absoluteString)
                    }
                })
                
            }
        }
    }
    
    
    func clearCurrentUser() {
        self.currentUser = ProfileUser()
    }
}
