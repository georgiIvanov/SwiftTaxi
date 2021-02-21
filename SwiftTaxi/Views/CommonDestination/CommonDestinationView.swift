//
//  CommonDestinationView.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import SwiftUI

struct CommonDestinationView: View {
    let place: Place
    let action: () -> Void

    var body: some View {
        VStack {
            Text(place.name)
                .font(.caption)
                .bold()
                .lineLimit(nil)
                .padding(.top, 8.0)
                .padding([.leading, .trailing], 4.0)
            Spacer()
            HStack {
                Image(systemName: "car")
                    .padding(8)
                Spacer()
                Image(systemName: "mappin.and.ellipse")
                    .padding(8)
            }
        }.padding(0)
            .background(Color.blue.opacity(0.33))
            .cornerRadius(12)
            .onTapGesture {
                action()
            }
    }
}

struct CommonDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        CommonDestinationView(place: .mallBulgaria,
                              action: { })
            .previewLayout(.sizeThatFits)
    }
}
