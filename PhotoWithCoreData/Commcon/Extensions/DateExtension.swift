//
//  DateExtension.swift
//  PhotoWithCoreData
//
//  Created by jongjin seok on 2018. 2. 11..
//  Copyright © 2018년 jongjin seok. All rights reserved.
//


import Foundation

extension Date {
    
    func yearAndMonth() -> String {
        let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 32400)
            dateFormatter.dateFormat = "yyyy년 MM월"
         return dateFormatter.string(from: self)
    }
    
    func updateDate() -> String {
       
        let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 32400)
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        return dateFormatter.string(from: self)
        
    }
}

