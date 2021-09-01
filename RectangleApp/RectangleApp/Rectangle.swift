//
//  Rectangle.swift
//  RectangleApp
//
//  Created by Laura Bejan on 10.08.2021.
//

import UIKit

class Rectangle: UIView {

    var hue: CGFloat = CGFloat.random(in: 0...1) {
        didSet {
            backgroundColor = randomColor
        }
    }

    private var randomColor: UIColor {
        UIColor(hue: hue,
                saturation: CGFloat.random(in: 0...1),
                brightness: CGFloat.random(in: 0...1),
                alpha: 0.75)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = randomColor
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
