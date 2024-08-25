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
    @IBOutlet private weak var orangeView: UIView!
    var webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewA.backgroundColor = .clear
        viewA.addSubview(webView)
        webView.pinEdgesToSuperviewEdges()
        // stackView.layer.masksToBounds = true <- interface Builder에서 설정함.
        
        if let url = URL(string: "https://www.apple.com") {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if traitCollection.verticalSizeClass != .compact {
            self.orangeView.isHidden = true
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        coordinator.animate(alongsideTransition: {_ in
            if newCollection.verticalSizeClass == .compact {
                self.orangeView.isHidden = false
            } else {
                self.orangeView.isHidden = true
            }
        })
    }
}
