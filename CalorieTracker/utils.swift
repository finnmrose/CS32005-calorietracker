//
//  utils.swift
//  CalorieTracker
//
//  Created by Rose on 19/11/2026.
//

import Foundation

enum UTILS {
    static var SHORT_FORMAT: FloatingPointFormatStyle<Float> { return FloatingPointFormatStyle<Float>.number.precision(.fractionLength(0...1)).precision(.significantDigits(1...3)) }
}
