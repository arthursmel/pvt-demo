//
//  WebViewPvtViewController.swift
//  DemoPvt
//
//  Created by Mel Arthurs on 28/04/2021.
//

import UIKit
import WebKit

class WebViewPvtViewController: UIViewController {

    private var webView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        let path = Bundle.main.path(forResource: "pvt", ofType: "html")!
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        webView?.load(request)
    }
    
    func setupView() {        
        webView = WKWebView()
        webView!.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView!)
        
        NSLayoutConstraint.activate([
            webView!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webView!.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            webView!.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            webView!.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        ])
    }

}
