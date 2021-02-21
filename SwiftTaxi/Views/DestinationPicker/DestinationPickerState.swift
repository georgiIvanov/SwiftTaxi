//
//  DestinationPickerState.swift
//  SwiftTaxi
//
//  Created by Voro on 21.02.21.
//

import Foundation
import MapKit

struct DestinationPickerState: Equatable {
    var selectedRegion: MKCoordinateRegion {
        let commonDelta: CLLocationDegrees = 25 / 111
        let span = MKCoordinateSpan(
            latitudeDelta: commonDelta,
            longitudeDelta: commonDelta)
        return MKCoordinateRegion(center: selectedLocation.coordinate,
                                  span: span)
    }

    var selectedLocation = CLLocation()
    var from: String = ""
    var to: String = ""
    var lastEditing: Direction = .to
    
    var fromPlace: Place = .empty
    var toPlace: Place = .empty
    
    var searchResult: [Place] = []
}

extension DestinationPickerState {
    var currentPickingPlace: Place? {
        switch lastEditing {
        case .from:
            return fromPlace
        case .to:
            return toPlace
        }
    }
    
    var pickedBothPlaces: Bool {
        return fromPlace != .empty && toPlace != .empty
    }
    
    mutating func setPlace(_ place: Place, forDirection: Direction) {
        switch forDirection {
        case .from:
            fromPlace = place
            from = place.name
        case .to:
            toPlace = place
            to = place.name
        }
    }
}
