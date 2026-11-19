//
//  Portion.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//

import Foundation
import SwiftData

enum Portion: CaseIterable, Identifiable, CustomStringConvertible, Codable {
    var id: Self { self }
    case none
    case count
    case weight
    case volume
    
    var description: String {
        switch self {
        case .count:
            return "Count"
        case .weight:
            return "Weight"
        case .volume:
            return "Volume"
        default:
            return "None"
        }
    }
    
    var unit: String {
        switch self {
        case .weight:
            return "g"
        case .volume:
            return "ml"
        default:
            return ""
        }
    }
    
    var alt_unit: String {
        switch self {
        case .count:
            return "portion"
        case .weight:
            return "100g"
        case .volume:
            return "100ml"
        default:
            return "none"
        }
    }
    
    var big_unit: String {
        switch self {
        case .weight:
            return "kg"
        case .volume:
            return "L"
        default:
            return ""
        }
    }
    
    var isNone: Bool {
        switch self {
        case .none:
            return true
        default:
            return false
        }
    }
    
    var input_scale: Float {
        switch self {
        case .weight, .volume:
            return 0.01
        case .count:
            return 1
        default:
            return 1
        }
    }
    
    var isDiscrete: Bool {
        switch self {
        case .count:
            return true
        default:
            return false
        }
    }
    
    var isContinuous: Bool {
        switch self {
        case .weight, .volume:
            return true
        default:
            return false
        }
    }
}
