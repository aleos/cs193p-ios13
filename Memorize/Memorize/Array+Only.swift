//
//  Array+Only.swift
//  Memorize
//
//  Created by Alexander Ostrovsky on 08.02.2021.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
