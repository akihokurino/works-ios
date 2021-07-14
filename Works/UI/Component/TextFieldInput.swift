//
//  TextFieldInput.swift
//  Works
//
//  Created by akiho on 2021/07/15.
//

import SwiftUI

struct TextFieldInput: View {
    @Binding var value: String

    let label: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(Color.gray)
                .fontWeight(.bold)
                .font(.body)
            TextField("", text: $value, onEditingChanged: { _ in

            }, onCommit: {})
                .keyboardType(keyboardType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 45)
        }
    }
}

struct TextFieldInput_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldInput(value: .constant(""), label: "氏名", keyboardType: .default).frame(width: 320, height: 200)
    }
}
