//
//  UserServiceHelperMethods.swift
//  Ditlo
//
//  Created by Harry Ferrier on 1/18/19.
//  Copyright © 2019 harryferrier. All rights reserved.
//

import Foundation

//func modelDataToCustomMonthClass(withDitloMonthData monthData: (key: String, value: [DitloVideo]), completion: (Month) -> ()) {
//    var month: Month = Month(name: monthData.key, days: [])
//    
//    var ditlosInDays: [String: [DitloVideo]] = [:]
//    var numberOfReturnedDayCompletions: Int = 0
//
//    for ditlo in monthData.value {
//        let date = ditlo.timeStamp.dateValue()
//        let dateAndDayName = date.getDateAndDayName()
//
//        if ditlosInDays.keys.contains(dateAndDayName) {
//            ditlosInDays[dateAndDayName]?.append(ditlo)
//        } else {
//            ditlosInDays[dateAndDayName] = [ditlo]
//        }
//    }
//
//    // send each day dictionary off for modelling work, where it will be returned as a 'Day' value
//    for day in ditlosInDays {
//        modelDataToCustomDayClass(withDitloDayData: day) { (day) in
//            month.days.append(day)
//            numberOfReturnedDayCompletions += 1
//            if numberOfReturnedDayCompletions == ditlosInDays.count {
//
//                // order the days
//                month.days.sort(by: { (day1, day2) -> Bool in
//                    let day1Date = Int(day1.day.split(separator: " ")[0])!
//                    let day2Date = Int(day2.day.split(separator: " ")[0])!
//                    return day1Date < day2Date
//                })
//
//                completion(month)
//            }
//        }
//    }
//}
//
//func modelDataToCustomDayClass(withDitloDayData dayData: (key: String, value: [DitloVideo]), completion: (Day) -> ()) {
//    var day: Day = Day(day: dayData.key, currentlyDisplayingDitlos: .own, userDitlos: [], taggedDitlos: [])
//
//    let userId = UserService.instance.currentUser.id
//    for ditloVideo in dayData.value {
//        if ditloVideo.videoOwnerId == userId {
//            if day.userDitlos.count == 0 {
//                day.userDitlos = [Ditlo(videos: [ditloVideo])]
//            } else {
//                day.userDitlos[0].videos.append(ditloVideo)
//                day.userDitlos[0].videos.sort { (d1, d2) -> Bool in
//                    let d1Date = d1.timeStamp.dateValue()
//                    let d2Date = d2.timeStamp.dateValue()
//                    return d1Date < d2Date
//                }
//            }
//        } else {
//            if day.taggedDitlos.count == 0 {
//                day.taggedDitlos = [Ditlo(videos: [ditloVideo])]
//            } else {
//                day.taggedDitlos[0].videos.append(ditloVideo)
//                day.taggedDitlos[0].videos.sort { (d1, d2) -> Bool in
//                    let d1Date = d1.timeStamp.dateValue()
//                    let d2Date = d2.timeStamp.dateValue()
//                    return d1Date < d2Date
//                }
//            }
//        }
//    }
//
//    completion(day)
//}
