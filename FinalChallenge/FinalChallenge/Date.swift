//
//  Date.swift
//  FinalChallenge
//
//  Created by Evandro Henrique Couto de Paula on 25/10/16.
//  Copyright © 2016 Evandro Henrique Couto de Paula. All rights reserved.
//

import Foundation


extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(abbreviation: "BRT")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
    }
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}


extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}
////HOW TO USE/////////////////////////////
//
//let stringFromDate = Date().iso8601    // "2016-06-18T05:18:27.935Z"
//
//if let dateFromString = stringFromDate.dateFromISO8601 {
//    print(dateFromString.iso8601)      // "2016-06-18T05:18:27.935Z"
//}
