//
//  FirebaseAdapter.swift
//  Showroom
//
//  Created by Luka Lešić on 02.11.2023..
//

import Foundation
import FirebaseFirestore

class FirebaseAdapter: Adapter {
    func adaptSnapshot(_ snapshot: DocumentSnapshot) -> ModelObject {
        let name = snapshot.data()?["test"] as? String ?? ""
        let modelURL = snapshot.data()?["modelURL"] as? String ?? ""
        let parentCollection = snapshot.reference.parent.collectionID
        let modelObject = ModelObject(name: name, modelURL: modelURL, parentCollection: parentCollection)
        return modelObject
    }
}
