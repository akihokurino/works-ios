import SwiftUI

struct MenuButton: View {
    let text: String
    let action: () -> Void
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(text)
                    .foregroundColor(Color.black)
                Spacer()
                Image(systemName: "chevron.forward")
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
}

struct MenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MenuButton(text: "メニュー", action: {})
    }
}
