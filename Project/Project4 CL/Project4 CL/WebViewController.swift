//
//  WebViewController.swift
//  Project4 CL
//
//  Created by R R on 18/12/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, UIPopoverPresentationControllerDelegate {
    var stringReceived: String?
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let weburl = stringReceived else { return }
        guard let url = URL(string: "https://" + weburl) else { return }
        webView.load(URLRequest(url:url))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
       
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let backward = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView.goForward))
        
        toolbarItems = [progressButton,spacer,backward,spacer,forward,spacer,refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
  
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        let url = navigationAction.request.url
        //guard let weburl = stringReceived else { return }
        
        if let host = url?.host {
            if host.contains("duckduckgo.com"){
                decisionHandler(.allow)
                return
            }else{
                alertVC()
            }

        }
        decisionHandler(.cancel)
    }
    
    func alertVC() {
        let avc = UIAlertController(title: "Error", message: "This website is blocked", preferredStyle: .alert)
        avc.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //avc.popoverPresentationController?.delegate = self
        present(avc, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
