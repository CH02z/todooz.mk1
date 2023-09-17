//
//  Extensions.swift
//  todooz.mk1
//
//  Created by Chris Zimmermann on 26.08.23.
//

import Foundation
import UIKit
import SwiftUI



//Extenstions-----------------------------------------------------------------------------------

extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

//got to settings of Notification
extension TabsView {
     func goToSettings(){
        // must execute in main thread
        DispatchQueue.main.async {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:],
            completionHandler: nil)
        }
    }
}


extension Date {
    func removeTimeStamp() -> Date? {
       guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
        return nil
       }
       return date
   }
}



//From Color to Hex
//Example usage: var color: Color
//color.toHex() --> String

extension Color {
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}



// From Hex to Color:
// Example usage: .backround(Color(hex: HexString))


extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}


//Helper Functions---------------------------------------------------------


func getCurrentDateString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "CEST")!
    dateFormatter.dateFormat = "d MMM YY, HH:mm:ss"
    return dateFormatter.string(from: date)
}

func getStringFromDate(date: Date, dateFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "CEST")!
    dateFormatter.dateFormat = dateFormat
    return dateFormatter.string(from: date)
}

func getDateFromString(dateString: String) -> Date {
    if !dateString.isEmpty {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "CEST")
        if dateString.count > 11 {
            dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            let dObj = dateFormatter.date(from: dateString)
            return dObj ?? Date()
            
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.date(from: dateString)!
        }
    } else {
        print("empty input datestring, returning date()")
        return Date()
    }

}

func isSameDay(date1: Date, date2: Date) -> Bool {
    
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "CEST")!

    
    if calendar.isDate(date1, inSameDayAs: date2) {
        //print("date1 now object: \(date1), and date 2: \(date2)")
        return true
    } else {
        return false
    }
}


func dateIsInPast(inputDate: Date) -> Bool {
    return inputDate < Date()
}



func getHourDifferenceOfDates(startDate: Date, endDate: Date) -> Int {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "CEST")!
    let diffComponents = calendar.dateComponents([.hour, .minute], from: Date(), to: Date())
    let hours = diffComponents.hour
    return hours ?? 0
}


func getSubtractedDate(unit: String, value: Int, inputDate: Date) -> Date {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone(abbreviation: "CEST")!
    
    if unit == "Days" {
        return calendar.date(byAdding: .day, value: -value, to: inputDate)!
    }
    
    if unit == "Hours" {
        return calendar.date(byAdding: .hour, value: -value, to: inputDate)!
    }
    
    if unit == "Minutes" {
        //print("return date subtrcted by \(value) minutes")
        //print(calendar.date(byAdding: .minute, value: -value, to: inputDate)!)
        return calendar.date(byAdding: .minute, value: -value, to: inputDate)!
        
    }
    
    return Date()
    
}






