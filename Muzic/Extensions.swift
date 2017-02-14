//
//  UIView+Extensions.swift
//  Muzic
//
//  Created by Michael Ngo on 1/17/17.
//  Copyright © 2017 MIV Solution. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    func addConstraintsWithFormatString(format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
}


extension MutableCollection where Indices.Iterator.Element == Index {
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let r: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard r != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: r)
            let temp = self[firstUnshuffled]
            self[firstUnshuffled] = self[i]
            self[i] = temp
        }
    }
}
