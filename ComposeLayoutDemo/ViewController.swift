//
//  ViewController.swift
//  ComposeLayoutDemo
//
//  Created by Jun Gu on 2020/1/20.
//  Copyright © 2020 Jun Gu. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

var MyObservationContext = 0

class ViewController: UIViewController {

    let scrollView = UIScrollView()
    let webView = ComposerWebView(frame: CGRect())
    let upperRegion = UIView()

    var webviewHeightConstraint: Constraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red

        view.addSubview(scrollView)
        scrollView.addSubview(upperRegion)
        scrollView.addSubview(webView)

        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        upperRegion.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(141)
        }

        webView.snp.makeConstraints { (maker) in
            maker.top.equalTo(upperRegion.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().inset(1)
            maker.width.equalToSuperview()
            webviewHeightConstraint = maker.height.equalToSuperview().offset(-141).constraint
        }

        upperRegion.backgroundColor = .gray
        webView.backgroundColor = .blue
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .green
        webView.navigationDelegate = self

        var html = "<html><head><meta content='minimum-scale=0.1, user-scalable=no, width=device-width' name='viewport'><script type='text/javascript'><!--editor--></script></head><body onload='initEditor()'><div id='editor' contenteditable='true' style=''></div></body></html>"
        guard let filePath = Bundle.main.path(forResource: "editor", ofType: "js") else {
            return
        }
        guard let filePath0 = Bundle.main.path(forResource: "jQuery", ofType: "js") else {
            return
        }
        guard let filePath1 = Bundle.main.path(forResource: "ElementQueries", ofType: "js") else {
            return
        }
        guard let filePath2 = Bundle.main.path(forResource: "ResizeSensor", ofType: "js") else {
            return
        }
        
        do {
            let jsString = try String(contentsOfFile: filePath, encoding: .utf8)
            let jsString0 = try String(contentsOfFile: filePath0, encoding: .utf8)
            let jsString1 = try String(contentsOfFile: filePath1, encoding: .utf8)
            let jsString2 = try String(contentsOfFile: filePath2, encoding: .utf8)
            html = html.replacingOccurrences(of: "<!--editor-->", with: jsString0 + jsString1 + jsString2 + jsString)
        } catch {
        }
        webView.loadHTMLString(html, baseURL: nil)

        observeWebViewHeightChange()

//        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }

    @objc func timerFired() {
        let contentView = self.webView.scrollView.subviews.first!
        print("contentView.frame: ", contentView.frame)
    }

    func observeWebViewHeightChange() {
//        let contentView = self.webView.scrollView.subviews.first!
//        contentView.addObserver(self, forKeyPath: "frame", options: [.new, .old], context: nil)
//        contentView.observe(\UIView.frame, options: [.new]) { (_, change) in
//            let frame = change.newValue
//            print("kvo frame: ", frame)
//        }
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
            let context = context else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: nil)
            return
        }

        switch (keyPath, context) {
        case("contentSize", &MyObservationContext):
            print("contentSize height: ", webView.scrollView.contentSize.height)
            print(webviewHeightConstraint.layoutConstraints.first!.constant)
            webviewHeightConstraint.update(offset: webView.scrollView.contentSize.height-(webviewHeightConstraint.layoutConstraints.first!.constant))
            webView.invalidateIntrinsicContentSize()
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webviewHeightConstraint.update(offset: webView.scrollView.contentSize.height)
        webView.invalidateIntrinsicContentSize()
    }
}

var htmlContent: String {
    let js = """
        function getCursorPosition() {
            return window.getSelection().getRangeAt(0).getBoundingClientRect()
        }
    """
    var html = "<html><head><meta content='minimum-scale=0.1, user-scalable=no, width=device-width' name='viewport'><script type='text/javascript'>\(js)</script></head><body><div id='editor' contenteditable='true' style='height: 568' autocorrect='off' autocapitalize='on'>test<br/>test2</div></body></html>"
    guard let filePath = Bundle.main.path(forResource: "editor", ofType: "js") else {
        return ""
    }
    guard let filePath0 = Bundle.main.path(forResource: "jQuery", ofType: "js") else {
        return ""
    }
    guard let filePath1 = Bundle.main.path(forResource: "ElementQueries", ofType: "js") else {
        return ""
    }
    guard let filePath2 = Bundle.main.path(forResource: "ResizeSensor", ofType: "js") else {
        return ""
    }

//    do {
//        let jsString = try String(contentsOfFile: filePath, encoding: .utf8)
//        let jsString0 = try String(contentsOfFile: filePath0, encoding: .utf8)
//        let jsString1 = try String(contentsOfFile: filePath1, encoding: .utf8)
//        let jsString2 = try String(contentsOfFile: filePath2, encoding: .utf8)
//        html = html.replacingOccurrences(of: "<!--editor-->", with: jsString0 + jsString1 + jsString2 + jsString)
//    } catch {
//    }

    return html
}
