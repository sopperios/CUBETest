//
//  WebViewController.swift
//  CUBETest
//
//  Created by Mint on 2024/6/1.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    private var loadingIndicator: UIActivityIndicatorView!
    private var navTitle: String = ""
    private var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.navTitle
        
        self.loadingIndicator = UIActivityIndicatorView(style: .large)
        self.loadingIndicator.center = view.center
        self.view.addSubview(self.loadingIndicator)
        self.webView.navigationDelegate = self
        let url = URL(string: self.url)
        if let url = url {
            let request = URLRequest(url: url)
            self.webView.load(request)
            
        }
        
    }
    
    func setTitleAndUrl(title:String, url: String) {
        self.navTitle = title
        self.url = url
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.loadingIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.loadingIndicator.stopAnimating()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.loadingIndicator.stopAnimating()
    }
    
    
}
