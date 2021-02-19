//
//  DestinationDashboard.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import SwiftUI

struct DestinationDashboard: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    
                HStack {
                    Image(uiImage: #imageLiteral(resourceName: "TaxiCar"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.leading, 4.0)
                        .frame(maxWidth: 70)
                        
                    Text("Where to?")
                    Spacer()
                }
                
                
            }
            .padding(8)
            
            
            
            Spacer()
        }
        .background(Color.gray)
    }
}

struct DestinationDashboard_Previews: PreviewProvider {
    static var previews: some View {
        DestinationDashboard()
    }
}
