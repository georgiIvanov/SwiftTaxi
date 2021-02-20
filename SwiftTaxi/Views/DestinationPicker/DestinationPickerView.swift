//
//  DestinationPickerView.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import SwiftUI

struct DestinationPickerView: View {
    
    let filterResult = [Place(name: "fu1", latitude: 1, longitude: 1),
                        Place(name: "fu2", latitude: 1, longitude: 1),
                        Place(name: "fu3", latitude: 1, longitude: 1),
                        Place(name: "fu4", latitude: 1, longitude: 1),]
    
    var body: some View {
        List {
            ForEach(filterResult) { place in
                Text("\(place.name)")
            }
        }
    }
}

struct DestinationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        DestinationPickerView()
    }
}
