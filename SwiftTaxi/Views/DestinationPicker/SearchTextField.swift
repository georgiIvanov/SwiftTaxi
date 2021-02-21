//
//  SearchTextField.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct SearchTextField: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    let placeholder: String
    let prefixImageName: String?

    @State var isEditingInternal: Bool = false
    let viewStore: ViewStore<DestinationPickerState, DestinationPickerAction>

    init(viewStore: ViewStore<DestinationPickerState, DestinationPickerAction>,
         direction: Direction,
         text: Binding<String>,
         systemImage: String? = nil) {
        self.viewStore = viewStore
        switch direction {
        case .from:
            placeholder = "Where from?"
        case .to:
            placeholder = "Where to?"
        }
        _text = text
        _isEditing = viewStore.binding(get: { _ in false },
                                       send: { _ in DestinationPickerAction.editing(direction)
                                       })
        prefixImageName = systemImage
    }

    var body: some View {
        HStack {
            Image(systemName: isEditingInternal ? "magnifyingglass" : "circle")

            TextField(placeholder, text: $text, onEditingChanged: { editing in
                isEditing = editing
                isEditingInternal = editing

            })
                .font(.body)
                .padding(8)
                .background(Color.offWhite)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            if isEditingInternal {
                Divider()
                Button(action: {
                    viewStore.send(.presentModalMap(true, viewStore.lastEditing))
                }, label: {
                    Image(systemName: "map.fill")
                })
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
}
