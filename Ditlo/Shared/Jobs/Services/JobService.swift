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
    
    func getJobsList(withUserId userId: String? = nil, completion: @escaping jobListCompletion) {
        var jobsList: [Job] = []
        let jobsRef = db.collection(_JOBS)
        jobsRef.getDocuments { (snapshot, error) in
            if error != nil {
                print("Error", error?.localizedDescription)
            } else {
                if let documents = snapshot?.documents,
                    documents.count > 0 {
                    for job in documents {
                        let jobData = job.data()
                        let jobName = jobData["friendlyName"] as? String ?? "Couldn't retrieve job"
                        if userId != nil {
                            // check if it is their job and handle the isSelected state appropriately
                        } else {
                            let job = Job(jobName: jobName, isSelected: false)
                            jobsList.append(job)
                        }
                    }
                    
                    completion(jobsList)
                }
            }
        }
    }
}
