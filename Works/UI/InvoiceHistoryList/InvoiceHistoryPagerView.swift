import SwiftUI
import SwiftUIPager

enum InvoiceHistoryPagerType: Int {
    case normal
    case simple
}

struct InvoiceHistoryPagerView<Content: View>: View {
    @StateObject var page: Page = .first()
    let data: [InvoiceHistoryPagerType] = [.normal, .simple]
    let builder: (InvoiceHistoryPagerType) -> Content

    init(@ViewBuilder builder: @escaping (InvoiceHistoryPagerType) -> Content) {
        self.builder = builder
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    page.update(.moveToFirst)
                }) {
                    Text("通常")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40, alignment: .center)

                Spacer().frame(width: 1, height: 40, alignment: .center)
                    .background(Color.gray.opacity(0.5))

                Button(action: {
                    page.update(.moveToLast)
                }) {
                    Text("簡易")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 40, alignment: .center)
            }

            Divider().background(Color.gray.opacity(0.5))

            Pager(page: page,
                  data: data,
                  id: \.self,
                  content: { pagerType in
                      builder(pagerType)
                  })
        }
    }
}

struct InvoiceHistoryPagerView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceHistoryPagerView { _ in }
    }
}
