import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // Turn off scrolling (optional)
        webView.scrollView.isScrollEnabled = false
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

// Put your exact CSS here
let loaderCSS = """
<style>
.loader {
  position: relative;
  width: 2.5em;
  height: 2.5em;
  transform: rotate(165deg);
}

.loader:before, .loader:after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  display: block;
  width: 0.5em;
  height: 0.5em;
  border-radius: 0.25em;
  transform: translate(-50%, -50%);
}

.loader:before {
  animation: before8 2s infinite;
}

.loader:after {
  animation: after6 2s infinite;
}

@keyframes before8 {
  0% {
    width: 0.5em;
    box-shadow: 1em -0.5em rgba(225, 20, 98, 0.75),
                -1em 0.5em rgba(111, 202, 220, 0.75);
  }
  35% {
    width: 2.5em;
    box-shadow: 0 -0.5em rgba(225, 20, 98, 0.75),
                0 0.5em rgba(111, 202, 220, 0.75);
  }
  70% {
    width: 0.5em;
    box-shadow: -1em -0.5em rgba(225, 20, 98, 0.75),
                1em 0.5em rgba(111, 202, 220, 0.75);
  }
  100% {
    box-shadow: 1em -0.5em rgba(225, 20, 98, 0.75),
                -1em 0.5em rgba(111, 202, 220, 0.75);
  }
}

@keyframes after6 {
  0% {
    height: 0.5em;
    box-shadow: 0.5em 1em rgba(61, 184, 143, 0.75),
                -0.5em -1em rgba(233, 169, 32, 0.75);
  }
  35% {
    height: 2.5em;
    box-shadow: 0.5em 0 rgba(61, 184, 143, 0.75),
                -0.5em 0 rgba(233, 169, 32, 0.75);
  }
  70% {
    height: 0.5em;
    box-shadow: 0.5em -1em rgba(61, 184, 143, 0.75),
                -0.5em 1em rgba(233, 169, 32, 0.75);
  }
  100% {
    box-shadow: 0.5em 1em rgba(61, 184, 143, 0.75),
                -0.5em -1em rgba(233, 169, 32, 0.75);
  }
}

.loader {
  position: absolute;
  top: calc(50% - 1.25em);
  left: calc(50% - 1.25em);
}
</style>
"""

// HTML wrapper for the loader
let loaderHTML = """
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="initial-scale=1.0">
  \(loaderCSS)
</head>
<body style="margin:0; padding:0; background:#000; height:100vh; width:100vw;">
  <div class="loader"></div>
</body>
</html>
"""


struct CSSLoaderView: View {
    var body: some View {
        WebView(htmlContent: loaderHTML)
            // Optional frame if you want a specific size in SwiftUI
            .frame(width: 200, height: 200)
            // or expand to fill the parent
            //.edgesIgnoringSafeArea(.all)
    }
}

struct CSSLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        CSSLoaderView()
    }
}
