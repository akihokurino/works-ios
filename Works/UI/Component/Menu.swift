import SwiftUI

struct Menu<Next: View>: View {
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
            }
        }
        .isDetailLink(true)
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(text: "メニュー") {}.frame(width: 320, height: 50)
    }
}
