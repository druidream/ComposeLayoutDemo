//
//  StackViewController.swift
//  ComposeLayoutDemo
//
//  Created by Jun Gu on 2020/6/4.
//  Copyright © 2020 Jun Gu. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class StackViewController: UIViewController {
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let upperRegion = IntrinsicSizedView()
    let lowerRegion = IntrinsicSizedView()

    let webView = ComposerWebView(frame: .zero)
    var previousCursorFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(upperRegion)
        stackView.addArrangedSubview(webView)

        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }

        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        stackView.backgroundColor = .blue

        upperRegion.backgroundColor = .green

        webView.backgroundColor = .blue
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .green
        webView.scrollView.delegate = webView
        webView.navigationDelegate = self

        webView.loadHTMLString(htmlContent, baseURL: nil)

        observeWebViewHeightChange()
        observeKeyboardNotifications()
    }

    func observeWebViewHeightChange() {
        let options = NSKeyValueObservingOptions([.new])
        webView.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: options, context: &MyObservationContext)
    }

    func observeKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeShown(note:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath,
            let context = context else {
            super.observeValue(forKeyPath: nil, of: object, change: change, context: nil)
            return
        }

        switch (keyPath, context) {
        case(#keyPath(UIScrollView.contentSize), &MyObservationContext):
            print("contentSize height: ", webView.scrollView.contentSize.height)
            webView.invalidateIntrinsicContentSize()
        case("frame", &MyObservationContext):
            print("frame: ", webView.cursorView()?.frame)
            if previousCursorFrame != webView.cursorView()?.frame {
                previousCursorFrame = webView.cursorView()?.frame
                scrollCursorToVisible(animated: false)
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

extension StackViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("didFinish")
        webView.invalidateIntrinsicContentSize()
    }
}

extension StackViewController {
    @objc func keyboardWillBeShown(note: Notification) {
        print("keyboard show")
        print(scrollView.contentOffset)
        print(webView.cursorView()?.frame)
        scrollView.snp.updateConstraints { (maker) in
            // TODO: should use dynamic keyboard height
            maker.bottom.equalToSuperview().inset(300)
        }

//        self.webView.evaluateJavaScript("getCursorPosition()") { (returnValue, error) in
//            print("returnValue")
//            print(returnValue)
//        }
    }

    @objc func keyboardDidShow(note: Notification) {
        scrollCursorToVisible(animated: true)
        webView.cursorView()?.addObserver(self, forKeyPath: #keyPath(UIView.frame), options: .new, context: &MyObservationContext)
    }

    private func scrollCursorToVisible(animated: Bool) {
        let viewportHeight = 568 - 300
        let cursorFrame = webView.cursorView()!.frame
        let cursorTopMargin = 20 + 300 + 16 + Int(cursorFrame.minY)
        let scrollOffset = Int(scrollView.contentOffset.y)

        if cursorTopMargin - scrollOffset > viewportHeight {
            print("should scroll")
            let visibleRect = CGRect(x: 0, y: cursorTopMargin, width: 1, height: 1)
            print("visibleRect: ", visibleRect)
            scrollView.scrollRectToVisible(visibleRect, animated: animated)
        }
    }

    @objc func keyboardWillBeHidden(note: Notification) {
        print("keyboard hide")
        print(scrollView.contentOffset)
        scrollView.snp.updateConstraints { (maker) in
            maker.bottom.equalToSuperview()
        }
    }
}
