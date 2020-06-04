//
//  IntrinsicSizedView.swift
//  ComposeLayoutDemo
//
//  Created by Jun Gu on 2020/6/4.
//  Copyright © 2020 Jun Gu. All rights reserved.
//

import Foundation
import UIKit

class IntrinsicSizedView: UIView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 320, height: 300)
    }
}
