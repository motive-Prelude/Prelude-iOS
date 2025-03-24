//
//  Convertible.swift
//  Junction
//
//  Created by 송지혁 on 10/12/24.
//

import CloudKit

protocol Convertible {
    func toCKRecord() -> CKRecord
}
