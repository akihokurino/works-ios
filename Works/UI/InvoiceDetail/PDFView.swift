//

import PDFKit
import SwiftUI
import WebKit

struct PDFKitView: View {
    let data: URL?

    var body: some View {
        if let data = data {
            PDFKitRepresentedView(data)
        } else {
            Text("loading...")
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let data: URL?

    init(_ data: URL?) {
        self.data = data
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.displayDirection = .vertical
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        if let url = data {
            pdfView.document = PDFDocument(url: url)
        }
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {}
}
