//
//  Models.swift
//  GB8Firebase
//
//  Created by Александр Арсенюк on 10.12.2021.
//

import Foundation
import UIKit
import Firebase

class Wheels {
    let count: Int
    init(count: Int) {
        self.count = 4
    }
    
}

class FirebaseTractor {
    let name: String
    let color: String
    let model: Int
    let serialNumber: Int
    let wheels: Wheels
    let ref: DatabaseReference?
    
    init(name: String, color: String, model: Int) {
        self.name = name
        self.color = color
        self.model = model
        self.wheels = Wheels(count: 4)
        serialNumber = Int.random(in: 999...9999)
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let name = value["name"] as? String,
                let color = value["color"] as? String,
                let model: Int = value["model"] as? Int,
                let serialNumber = value["serialNumber"] as? Int,
                let wheelsDict = value["wheels"] as? [String: Any],
                let wheelsCount = wheelsDict["count"]  as? Int
        else {
            return nil
        }
        self.ref = snapshot.ref
        self.name = name
        self.color = color
        self.model = model
        self.wheels = Wheels(count: wheelsCount)
        self.serialNumber = serialNumber
    }
    
    func toDict() -> [String: Any] {
        return [
            "name": name,
            "color": color,
            "model": model,
            "serialNumber": serialNumber,
            "wheels": [ "count" : wheels.count]
        ]
    }
    
}
