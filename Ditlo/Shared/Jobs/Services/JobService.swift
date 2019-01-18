//
//  JobService.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation
import FirebaseFirestore

class JobService {
    
    static let instance = JobService()
    
    typealias jobListCompletion = ([Job]) -> ()
    
    // initialize the cloud firestore and storage buckets
    let db: Firestore = Firestore.firestore()
    
    required init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getJobsList(withUserId: String? = nil) {
        let jobsRef = db.collection(_JOBS).document("jobs-list")
        jobsRef.addSnapshotListener(includeMetadataChanges: false) { (document, error) in
            if error != nil {
                // do something here
                print("error is", error?.localizedDescription)
            } else {
                if let document = document, document.exists {
                    if let data = document.data() {
                        print(data)
                    }
                }
            }
        }
        
        // get the jobs list here and pass it back
    }
}
