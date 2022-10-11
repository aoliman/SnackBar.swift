//
//  UIView+Snapkit.swift
//  Pods-SnackBar.swift_Example
//
//  Created by Soliman Yousry on 9/14/20.
//

import UIKit
import SnapKit

extension UIView {
	
	func setupSubview(_ subview: UIView, setup: (ConstraintViewDSL) -> Void) {
		self.addSubview(subview)
		setup(subview.snp)
	}
	
}
