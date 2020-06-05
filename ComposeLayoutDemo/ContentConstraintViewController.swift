//
//  ContentConstraintViewController.swift
//  ComposeLayoutDemo
//
//  Created by Jun Gu on 2020/6/3.
//  Copyright © 2020 Jun Gu. All rights reserved.
//

import Foundation
import WebKit
import SnapKit

class ContentConstraintViewController: UIViewController {

    let scrollView = UIScrollView()
    let webView = WKWebView()
    let upperRegion = UIView()
    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .red

        view.addSubview(scrollView)
        scrollView.addSubview(upperRegion)
        scrollView.addSubview(webView)
        contentView = webView.browserView()

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
            maker.height.equalToSuperview().offset(-141)
        }

        contentView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(webView)
        }

        upperRegion.backgroundColor = .gray
        webView.backgroundColor = .blue
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .green
        webView.navigationDelegate = self

        webView.loadHTMLString(htmlContent, baseURL: nil)
    }

}

extension ContentConstraintViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        webviewHeightConstraint.update(offset: webView.scrollView.contentSize.height)
        webView.invalidateIntrinsicContentSize()
    }
}
