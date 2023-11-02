//
//  Adapter.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation
import FirebaseFirestore

protocol Adapter {
    func adaptSnapshot(_ snapshot: DocumentSnapshot) -> ModelObject
}
