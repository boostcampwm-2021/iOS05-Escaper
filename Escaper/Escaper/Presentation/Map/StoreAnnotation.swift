//
//  StoreAnnotation.swift
//  Escaper
//
//  Created by TakHyun Jung on 2021/11/23.
//

import Foundation
import MapKit

class StoreAnnotation: NSObject {
    let store: Store

    init(store: Store) {
        self.store = store
    }
}

extension StoreAnnotation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return self.store.geoLocation.coordinate
    }
    var title: String? {
        return self.store.name
    }
}
