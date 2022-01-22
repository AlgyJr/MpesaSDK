//
//  Double+CustomFormat.dart.swift
//  MpesaiOSImplExample
//
//  Created by ALgy Aly on 22/01/22.
//

import Foundation

extension Double {
    func formatMTCurrency() -> String {
        return String(format: "%.2f MT", self)
    }
}
