//
//  TimeInterval.swift
//  Lenta
//
//  Created by Alex on 15.02.2021.
//

import Foundation

extension TimeInterval {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        let nowDate = Date()
        let nowDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nowDate)
        guard let startNowDate = Calendar.current.date(from: nowDateComponents) else { return "" }
        let startNowDateTimeInterval = startNowDate.timeIntervalSince1970
        var dateString = ""
        let secondsPerDay: Double = 24 * 60 * 60
        dateFormatter.dateFormat = "HH:mm "
        if self - startNowDateTimeInterval > 0 {
            dateString = "today in "
        } else if self - startNowDateTimeInterval + secondsPerDay > 0 {
            dateString = "yesterday in "
        } else {
            dateString = ""
            dateFormatter.dateFormat = "HH:mm  d MMMM yyyy"
        }
        return dateString + dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
}
