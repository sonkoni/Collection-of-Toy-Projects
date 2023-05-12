//
//  ViewControllerA.swift
//  AutoLayout_Adaptivity
//
//  Created by Kwan Hyun Son on 2023/05/10.
//

import UIKit
import WebKit

final class ViewControllerA: UIViewController {
    
    // MARK: - Property
     @IBOutlet private weak var viewA: UIView!
    var webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewA.backgroundColor = .clear
        viewA.addSubview(webView)
        webView.mgrPinEdgesToSuperviewEdges()
        
        if let url = URL(string: "https://www.apple.com") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}
