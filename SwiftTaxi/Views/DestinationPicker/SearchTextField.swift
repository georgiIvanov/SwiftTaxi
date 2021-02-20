//
//  SearchTextField.swift
//  SwiftTaxi
//
//  Created by Voro on 20.02.21.
//

import Foundation
import SwiftUI

struct SearchTextField<Content: View>: View {
    
    @Binding var text: String
    let prefixImageName: String?
    let content: Content?
    
    
    init(text: Binding<String>, @ViewBuilder content: () -> Content?, systemImage: String? = nil) {
        self._text = text
        self.prefixImageName = systemImage
        self.content = content()
    }
    
    var body: some View {
        HStack {
            if let name = prefixImageName {
                Image(systemName: name)
            }
            TextField("", text: $text)
            .font(.body)
            .padding(8)
            .background(Color.green)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            if let content = content {
                Divider()
                    .frame(width: 1, height: 50, alignment: .center)
                content
            }
        }
    }
}
