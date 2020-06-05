//
//  ComposerWebView.swift
//  ComposeLayoutDemo
//
//  Created by Jun Gu on 2020/6/3.
//  Copyright © 2020 Jun Gu. All rights reserved.
//

import Foundation
import WebKit

class ComposerWebView: WKWebView {

    init(frame: CGRect) {
        let configuration = WKWebViewConfiguration()
        super.init(frame: frame, configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
//        print("intrinsicContentSize: ", self.scrollView.contentSize)
        let minHeight = CGFloat(568.0)
        return CGSize(width: 320, height: max(minHeight, self.scrollView.contentSize.height))
//        return self.scrollView.contentSize
    }
}

extension ComposerWebView: UIScrollViewDelegate {
    // force inner scrollView stay un-scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

extension WKWebView {
    func browserView() -> UIView? {
        for subview in scrollView.subviews {
            if NSStringFromClass(type(of: subview)).starts(with: "WKContentView") {
                return subview
            }
        }

        return nil
    }

    func cursorView() -> UIView? {
        for subview in scrollView.subviews {
            print("cursor view outer loop: ", subview)
            if NSStringFromClass(type(of: subview)).starts(with: "UIView") {
                for sub in subview.subviews {
                    print("cursor view inner loop: ", sub)
                    if NSStringFromClass(type(of: sub)).starts(with: "UITextSelectionView") {
                        return sub.subviews.first;
                    }
                }
            }
        }

        return nil
    }
}
