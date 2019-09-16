//
//  Date+Extension.swift
//  moxie
//
//  Created by Tymofii Dolenko on 9/10/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var intervalString: String {
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let components = calendar.dateComponents(unitFlags, from: Date(), to: Date().addingTimeInterval(self))
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: true)
    }
    
}


struct DateComponentUnitFormatter {
    
    private struct DateComponentUnitFormat {
        let unit: Calendar.Component
        
        let singularUnit: String
        let pluralUnit: String
        
        let futureSingular: String
        let pastSingular: String
    }
    
    private let formats: [DateComponentUnitFormat] = [
        
        DateComponentUnitFormat(unit: .year,
                                singularUnit: "year",
                                pluralUnit: "years",
                                futureSingular: "Next year",
                                pastSingular: "Last year"),
        
        DateComponentUnitFormat(unit: .month,
                                singularUnit: "month",
                                pluralUnit: "months",
                                futureSingular: "Next month",
                                pastSingular: "Last month"),
        
        DateComponentUnitFormat(unit: .weekOfYear,
                                singularUnit: "week",
                                pluralUnit: "weeks",
                                futureSingular: "Next week",
                                pastSingular: "Last week"),
        
        DateComponentUnitFormat(unit: .day,
                                singularUnit: "day",
                                pluralUnit: "days",
                                futureSingular: "Tomorrow",
                                pastSingular: "Yesterday"),
        
        DateComponentUnitFormat(unit: .hour,
                                singularUnit: "hour",
                                pluralUnit: "hours",
                                futureSingular: "In an hour",
                                pastSingular: "An hour ago"),
        
        DateComponentUnitFormat(unit: .minute,
                                singularUnit: "minute",
                                pluralUnit: "minutes",
                                futureSingular: "In a minute",
                                pastSingular: "A minute ago"),
        
        DateComponentUnitFormat(unit: .second,
                                singularUnit: "second",
                                pluralUnit: "seconds",
                                futureSingular: "Just now",
                                pastSingular: "Just now"),
        
        ]
    
    func string(forDateComponents dateComponents: DateComponents, useNumericDates: Bool) -> String {
        for format in self.formats {
            let unitValue: Int
            
            switch format.unit {
            case .year:
                unitValue = dateComponents.year ?? 0
            case .month:
                unitValue = dateComponents.month ?? 0
            case .weekOfYear:
                unitValue = dateComponents.weekOfYear ?? 0
            case .day:
                unitValue = dateComponents.day ?? 0
            case .hour:
                unitValue = dateComponents.hour ?? 0
            case .minute:
                unitValue = dateComponents.minute ?? 0
            case .second:
                unitValue = dateComponents.second ?? 0
            default:
                assertionFailure("Date does not have requried components")
                return ""
            }
            
            return "\(unitValue) \(format.pluralUnit)"
        }
        
        return "Just now"
    }
}

extension Date {
    
    func timeAgoSinceNow(useNumericDates: Bool = false) -> String {
        
        let calendar = Calendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let components = calendar.dateComponents(unitFlags, from: self, to: now)
        
        let formatter = DateComponentUnitFormatter()
        return formatter.string(forDateComponents: components, useNumericDates: useNumericDates)
    }
    
}

extension Date {
    func isInSameWeek(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .weekOfYear)
    }
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
    func isInSameYear(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .year)
    }
    func isInSameDay(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .day)
    }
    var isInYesterday: Bool {
        return Calendar.current.isDate(self, equalTo: Date().addingTimeInterval(-(Double(60 * 60 * 24))), toGranularity: .day)
    }
    var isInThisWeek: Bool {
        return isInSameWeek(date: Date())
    }
    var isInToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isInTheFuture: Bool {
        return Date() < self
    }
    var isInThePast: Bool {
        return self < Date()
    }
    
    func isInTwoWeekPeriod(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: Date().addingTimeInterval(-(Double(60 * 60 * 24 * 14))), toGranularity: .day)
    }
    
    
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: midnight)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var midnight: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func isInTwoWeek() -> Date {
        return Calendar.current.date(byAdding: .day, value: -15, to: Date())!
    }
    
    func pastTwoWeeks() -> Bool {
        //X.pastTwoWeeks() -> Is X in past two weeks range from today?
        return self > isInTwoWeek()
    }
}
