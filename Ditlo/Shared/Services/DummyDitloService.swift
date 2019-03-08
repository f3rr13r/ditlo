//
//  DummyDitloService.swift
//  Ditlo
//
//  Created by Harry Ferrier on 2/7/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class DummyDitloService {
    
    static let instance = DummyDitloService()
    
    // initialize the cloud firestore and storage buckets
    let db: Firestore = Firestore.firestore()
    let storage: Storage = Storage.storage()
    
    required init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getTestDitlo(completion: @escaping (UIImage?, Bool) -> ()) {
        
        db.collection(_DITLOS).document("0917B33B-5BA9-4A68-B481-A006AFA8F764").getDocument { (snapshot, error) in
            if error != nil {
                completion(nil, false)
            } else {
                if let data = snapshot?.data() {
                    if let ditloThumbnailString = data["videoThumbnailUrlString"] as? String {
                        do {
                            let imageData = try Data(contentsOf: URL(string: ditloThumbnailString)!)
                            let profileImage = UIImage(data: imageData)
                            completion(profileImage, true)
                        } catch {
                            completion(nil, false)
                        }
                    } else {
                        completion(nil, false)
                    }
                } else {
                    completion(nil, false)
                }
            }
        }
    }
}
