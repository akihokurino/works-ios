import SwiftUI
import WebKit

struct MisocaOAuthView: View {
    var body: some View {
        WebView()
    }
}

struct MisocaOAuthView_Previews: PreviewProvider {
    static var previews: some View {
        MisocaOAuthView()
    }
}

struct WebView: UIViewControllerRepresentable {
    let loadUrl = "https://app.misoca.jp/oauth2/authorize?client_id=jGKRHV2hW_t4kn0w4Ma1Jxo_XkZxUA37rqFPRiYT61k&redirect_uri=https://works-prod.web.app&response_type=code&scope=write"

    func makeCoordinator() -> WebView.Coodinator {
        return Coodinator(self)
    }

    func makeUIViewController(context: Context) -> EmbeddedWebviewController {
        let webViewController = EmbeddedWebviewController(coordinator: context.coordinator)
        webViewController.loadUrl(url: self.loadUrl)

        return webViewController
    }

    func updateUIViewController(_ uiViewController: EmbeddedWebviewController, context: UIViewControllerRepresentableContext<WebView>) {}

    class Coodinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
            if let urlString = navigationAction.request.url?.absoluteString, urlString.hasPrefix("https://works-prod.web.app") {
                let url = URLComponents(string: urlString)!
                let code = url.queryItems?.first(where: { $0.name == "code" })?.value
                print("認証コード")
                print(code)
            }
            decisionHandler(.allow)
        }
    }
}

class EmbeddedWebviewController: UIViewController {
    var webview: WKWebView

    public var delegate: WebView.Coordinator?

    init(coordinator: WebView.Coordinator) {
        self.delegate = coordinator
        self.webview = WKWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.webview = WKWebView()
        super.init(coder: coder)
    }

    public func loadUrl(url: String) {
        self.webview.load(URLRequest(url: URL(string: url)!))
    }

    override func loadView() {
        self.webview.navigationDelegate = self.delegate
        self.webview.uiDelegate = self.delegate
        view = self.webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
