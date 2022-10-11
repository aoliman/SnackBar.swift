//
//  SnackBarStyle.swift
//  CommonUI
//
//  Created by Soliman Yousry on 9/11/20.
//

import UIKit

public struct SnackBarStyle {
	public init() { }
	// Container
	public var background: UIColor = .lightGray
	var padding = 16
	var inViewPadding = 20
	// Label
	public var textColor: UIColor = .black
    public var font: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 14))
	var maxNumberOfLines: UInt = 2
	// Action
	public var actionTextColorAlpha: CGFloat = 0.5
	public var actionFont: UIFont = UIFont.systemFont(ofSize: UIFontMetrics.default.scaledValue(for: 17))
	public var actionTextColor: UIColor = .red
}
