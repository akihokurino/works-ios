import PDFKit
import SwiftUI
import WebKit

struct PDFKitView: View {
    let data: URL?

    var body: some View {
        // PDFKitを表示するときにはURLが存在しないといけない
        if let data = data {
            PDFKitRepresentedView(data)
        } else {
            Text("loading...")
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let data: URL

    init(_ data: URL) {
        self.data = data
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.document = PDFDocument(url: data)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {}
}
