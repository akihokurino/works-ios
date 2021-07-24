//

import PDFKit
import SwiftUI
import WebKit

// struct PDFKitView: View {
//    let url: URL
//
//    var body: some View {
//        PDFKitRepresentedView(url)
//    }
// }
//
// struct PDFKitRepresentedView: UIViewRepresentable {
//    let url: URL
//
//    init(_ url: URL) {
//        self.url = url
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
//        let pdfView = PDFView()
//        pdfView.document = PDFDocument(url: self.url)
//        return pdfView
//    }
//
//    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {}
// }

struct PDFKitView: View {
    let url: URL

    var body: some View {
        PDFWebView(loadUrl: url.absoluteString)
    }
}

struct PDFKitView_Previews: PreviewProvider {
    static var previews: some View {
        PDFKitView(url: URL(string: "")!)
    }
}

struct PDFWebView: UIViewRepresentable {
    var loadUrl: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: URL(string: loadUrl)!))
    }
}
