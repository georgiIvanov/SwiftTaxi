//
//  CommonDestinationView.swift
//  SwiftTaxi
//
//  Created by Voro on 19.02.21.
//

import SwiftUI
import ComposableArchitecture

enum CommonDestinationAction {
    case setDestination(Place)
}

struct CommonDestinationView: View {
    enum Size {
        case s
        case m
        case l
    }
    
    let store: Store<Place, CommonDestinationAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.name)
                    .font(.caption)
                    .lineLimit(nil)
                    .padding([.top, .leading, .trailing], 4.0)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Image(systemName: "car")
                        .padding(8)
                    Spacer()
                    Image(systemName: "mappin.and.ellipse")
                        .padding(8)
                }
            }.padding(0)
            .background(Color.green.opacity(0.5))
            .withSize(.m)
            .onTapGesture {
                viewStore.send(.setDestination(viewStore.state))
            }
        }
    }
}

fileprivate extension View {
    func withSize(_ size: CommonDestinationView.Size) -> some View {
        let height: CGFloat = 90
        var width: CGFloat = 160
        switch size {
        case .s:
            width = 90
        case .m:
            width = 140
        case .l:
            width = 200
        }
        
        return frame(width: width, height: height, alignment: .center)
    }
}

struct CommonDestinationView_Previews: PreviewProvider {
    static var previews: some View {
        CommonDestinationView(store: Store(initialState: .mallBulgaria,
                                    reducer: commonDestinationReducer,
                                    environment: ()))
//            .edgesIgnoringSafeArea(.all)
            .previewLayout(.sizeThatFits)
//            .frame(width: 100.0, height: 100.0)
    }
}
