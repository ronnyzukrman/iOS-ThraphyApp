//
//  TermCondition_ViewController.swift
//  Therapy
//
//  Created by SIERRA on 12/18/18.
//  Copyright © 2018 SIERRA. All rights reserved.
//

import UIKit

class TermCondition_ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var urlLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: urlLink)
        let theRequest = NSMutableURLRequest(url: url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 0.0)
        self.webView.loadRequest((theRequest as URLRequest))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        showProgress()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hideProgress()
    }
}
