//
//  FieldValidating.swift
//  moxie
//
//  Created by ZacharyH on 1/30/18.
//  Copyright © 2018 Tomoki Takasawa. All rights reserved.
//

import UIKit

protocol FieldValidating : class {
    func validEmail(field: UITextField?) -> String?
    func validPassword(field: UITextField?) -> String?
    func validNonEmpty(field: UITextField?) -> String?
}

extension FieldValidating where Self:RoundedView {

    func validEmail(field: UITextField?) -> String? {
        guard let trimmedText = field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        
        guard let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return nil
        }
        
        let range = NSMakeRange(0, NSString(string: trimmedText).length)
        let allMatches = dataDetector.matches(in: trimmedText,
                                              options: [],
                                              range: range)
        
        if allMatches.count == 1, allMatches.first?.url?.absoluteString.contains("mailto:") == true {
            return trimmedText
        }
        return nil
    }
    
    func validPassword(field: UITextField?) -> String? {
        guard let text = field?.text else {
            return nil
        }
        if text.count >= 8 {
            return text
        }
        return nil
    }
    
    func validNonEmpty(field: UITextField?) -> String? {
        guard let trimmedText = field?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return nil
        }
        if !trimmedText.isEmpty {
            return trimmedText
        }
        return nil
    }

}
