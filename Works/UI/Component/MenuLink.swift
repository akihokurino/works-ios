import SwiftUI

struct MenuLink<Next: View>: View {
    let text: String
    let next: Next

    init(text: String, @ViewBuilder builder: () -> Next) {
        self.text = text
        self.next = builder()
    }

    var body: some View {
        NavigationLink(
            destination: next
        ) {
            HStack {
                Text(text)
                    .foregroundColor(Color.black)
                Spacer()
                Image(systemName: "chevron.forward")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .isDetailLink(true)
    }
}

struct MenuLink_Previews: PreviewProvider {
    static var previews: some View {
        MenuLink(text: "メニュー") {}.frame(width: 320, height: 50)
    }
}
