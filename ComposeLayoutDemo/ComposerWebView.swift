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
        print("intrinsicContentSize: ", self.scrollView.contentSize)
        let minHeight = CGFloat(568.0)
        return CGSize(width: 320, height: max(minHeight, self.scrollView.contentSize.height))
//        return self.scrollView.contentSize
    }
}
