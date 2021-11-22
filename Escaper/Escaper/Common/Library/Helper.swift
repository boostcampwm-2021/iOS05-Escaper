//
//  Helper.swift
//  Escaper
//
//  Created by 최완식 on 2021/11/11.
//

import Foundation

enum Helper {
    static func parseUsername(email: String) -> String? {
        return email.components(separatedBy: "@").first
    }

    static func binarySearch(value: Int, sortedValues: [Int]) -> Int? {
        var left = 0, right = sortedValues.count-1
        while left <= right {
            let mid = Int((left + right)/2)
            if sortedValues[mid] == value {
                return mid + 1
            } else if sortedValues[mid] > value {
                right = mid - 1
            } else if sortedValues[mid] < value {
                left = mid + 1
            }
        }
        return nil
    }

    static func measureDistance(_ distance: Double) -> String {
        return distance < 1000 ? "\(Int(distance))m" : "\((distance / 100).rounded() / 10)km"
    }
}
