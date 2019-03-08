//
//  CategoriesService.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/27/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CategoriesService {
    
    static let instance = CategoriesService()
    
    typealias categoryListCompletion = ([Category]) -> ()
    
    // initialize the cloud firestore and storage buckets
    let db: Firestore = Firestore.firestore()
    
    required init() {
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
    }
    
    func getCategoriesList(withUserId userId: String? = nil, completion: @escaping categoryListCompletion) {
        var categories: [Category] = []
        var numberOfDatabaseCategories: Int = 0
        let getCategoriesDispatchGroup = DispatchGroup()
        
        let categoriesRef = db.collection(_CATEGORIES)
        categoriesRef.getDocuments { (snapshot, error) in
            if error != nil {
            } else {
                if let documents = snapshot?.documents,
                    documents.count > 0 {
                    numberOfDatabaseCategories = documents.count
                    for category in documents {
                        if let categoryId = category.data()["id"] as? Int,
                            let categoryName = category.data()["friendlyName"] as? String {
                            var category = Category(
                                id: categoryId,
                                name: categoryName,
                                isSelected: false,
                                allCategoriesSelected: false,
                                backgroundColor: getCategoryColour(withId: categoryId),
                                childCategories: [])
                            let childCategoryRef = categoriesRef.document(categoryName).collection(_CHILD_CATEGORIES)
                            childCategoryRef.getDocuments(completion: { (snapshot, error) in
                                if error != nil {
                                } else {
                                    if let documents = snapshot?.documents,
                                        documents.count > 0 {
                                        let numberOfDatabaseChildCategories: Int = documents.count
                                        for childCategory in documents {
                                            // prefix an ALL setting to the childCategories
                                            if category.childCategories.count == 0 {
                                                let allCategory = ChildCategory(id: 0, name: "Toggle All \(category.name)", backgroundColor: category.backgroundColor, isSelected: false)
                                                category.childCategories.append(allCategory)
                                            }
                                            
                                            // add the childCategories
                                            if let childCategoryId = childCategory.data()["id"] as? Int,
                                                let childCategoryName = childCategory.data()["friendlyName"] as? String {
                                                let childCategory = ChildCategory(
                                                    id: childCategoryId,
                                                    name: childCategoryName,
                                                    backgroundColor: category.backgroundColor,
                                                    isSelected: false)
                                                category.childCategories.append(childCategory)
                                            }
                                        }
                                        categories.append(category)
                                        
                                        if categories.count == numberOfDatabaseCategories && category.childCategories.count == (numberOfDatabaseChildCategories + 1) {
                                            completion(categories)
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}

//class JobService {
//
//    static let instance = JobService()
//
//    typealias jobListCompletion = ([Job]) -> ()
//
//    // initialize the cloud firestore and storage buckets
//    let db: Firestore = Firestore.firestore()
//
//    required init() {
//        let settings = db.settings
//        settings.areTimestampsInSnapshotsEnabled = true
//        db.settings = settings
//    }
//
//    func getJobsList(withUserId userId: String? = nil, completion: @escaping jobListCompletion) {
//        var jobsList: [Job] = []
//        let jobsRef = db.collection(_JOBS)
//        jobsRef.getDocuments { (snapshot, error) in
//            if error != nil {
//                print("Error", error?.localizedDescription)
//            } else {
//                if let documents = snapshot?.documents,
//                    documents.count > 0 {
//                    for job in documents {
//                        let jobData = job.data()
//                        let jobName = jobData["friendlyName"] as? String ?? "Couldn't retrieve job"
//                        if userId != nil {
//                            // check if it is their job and handle the isSelected state appropriately
//                        } else {
//                            let job = Job(jobName: jobName, isSelected: false)
//                            jobsList.append(job)
//                        }
//                    }
//
//                    completion(jobsList)
//                }
//            }
//        }
//    }
//}
