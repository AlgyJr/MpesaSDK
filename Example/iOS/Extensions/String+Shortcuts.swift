//
//  String+Shortcuts.swift
//  MpesaiOSImplExample
//
//  Created by ALgy Aly on 22/01/22.
//

import Foundation

extension String {
    func isValidPhone() -> Bool {
        let pattern = #"^[+]?(258)?84[0-9]{7}"#
        let range = NSRange(location: 0, length: self.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    mutating func normalizePhoneNumber() {
        if self.starts(with: "84") {
            self = "258\(self)"
        } else if self.starts(with: "+") {
            self.removeFirst()
        }
    }
}
