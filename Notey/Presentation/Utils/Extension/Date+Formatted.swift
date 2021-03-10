//
//  Date+Formatted.swift
//  Notey
//
//  Created by Arif Luthfiansyah on 07/03/21.
//

import Foundation

extension Date {
    
    func formatted(
        components: [FormatterComponent]
    ) -> String {
        let dateFormatter = DateFormatter()
        var dateFormat: String = ""
        for (index, component) in components.enumerated() {
            dateFormat = index == .zero ?
                component.rawValue :
                dateFormat + component.rawValue
        }
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    enum FormatterComponent: String, CaseIterable {
        case dayOfMonth = "d"
        case dayOfMonthPadding = "dd"
        case dayOfWeekInMonth = "F"
        case dayOfWeekAbbreviationName = "E"
        case dayOfWeekWideName = "EEEE"
        case dayOfWeekNarrowName = "EEEEE"
        case dayOfWeekShortName = "EEEEEE"
        case monthOfYearSingle = "M"
        case monthOfYearDouble = "MM"
        case monthOfYearShorthandName = "MMM"
        case monthOfYearFullName = "MMMM"
        case monthOfYearNarrowName = "MMMMM"
        case yearFullDigits = "yyyy"
        case yearTwoDigits = "yy"
        case hour12 = "h"
        case hour12Padding = "hh"
        case hour24 = "H"
        case hour24Padding = "HH"
        case meridiem = "a"
        case minute = "m"
        case minutePadding = "mm"
        case second = "s"
        case secondPadding = "ss"
        case millisecond = "SSS"
        case dash = "-"
        case dot = "."
        case colon = ":"
        case comma = ","
        case underscore = "_"
        case whitespace = " "
    }
    
}
