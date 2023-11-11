//
//  Double+Extensions.swift
//  MyUber
//
//  Created by Даниил Кизельштейн on 11.11.2023.
//

import Foundation

extension Double {
    
    /// Convert a Double into a Currency with 2 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.usesGroupingSeparator = true
        nf.locale = .current
        nf.currencyCode = "usd"
        nf.currencySymbol = "$"
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return nf
    }
    
    /// Convert a Double into a Currency as String with 2 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    /// Convert a Double into String representation
    /// ```
    /// Convert 12.3456 to "12.35"
    /// ```
    func asNumberString() -> String {
        String(format: "%.2f", self)
    }
}
