//
//  SnackBar.swift
//  CommonUI
//
//  Created by Ahmad Almasri on 9/7/20.
//

import Foundation
import UIKit
import SnapKit

public protocol SnackBarAction {
    func setAction(for actionButton:UIButton, action: (() -> Void)?) -> SnackBarPresentable
}

public protocol SnackBarPresentable {
    
    func show()
    func dismiss()
}

open class SnackBar: UIView, SnackBarAction, SnackBarPresentable {
    

    
    
    

    
    open var style: SnackBarStyle {
        
        return SnackBarStyle()
    }
    private let contextView: UIView
    private let mainView: UIView
    private let message: String
    private let duration: Duration
    private var dismissTimer: Timer?
    
    required public init(contextView: UIView,mainView:UIView,duration: Duration) {
        self.contextView = contextView
        self.duration = duration
        super.init(frame: .zero)
        self.backgroundColor = style.background
        self.layer.cornerRadius = 5
        self.mainView = mainView
        setupView()
        setupSwipe()
    }
    
    required public init?(coder: NSCoder) {
        return nil
    }
    
    private func constraintSuperView(with view: UIView) {
    
        view.setupSubview(self) {
            
            $0.makeConstraints {
                $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(200)
                $0.leading.equalTo(view.safeAreaLayoutGuide).offset(style.padding)
                $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-style.padding)
            }
        }
        
    }
    private func setupView() {
        
        self.setupSubview(mainView) {
            
            $0.makeConstraints {
                $0.bottom.trailing.equalTo(self).offset(-style.inViewPadding)
                $0.top.leading.equalTo(self).offset(style.inViewPadding)
            }
        }
    }
    
    private func setupSwipe() {
        
        self.addSwipeGestureAllDirection(action: #selector(self.swipeAction(_:)))

    }
    
    @objc private func swipeAction(_ sender: UISwipeGestureRecognizer) {
        
        self.dismiss()
        
    }
    
    private static func removeOldViews(form view: UIView) {
        
        view.subviews
            .filter({ $0 is Self })
            .forEach({ $0.removeFromSuperview() })

    }
    
    private func animation(with offset: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        superview?.layoutIfNeeded()
            
            self.snp.updateConstraints {
                $0.bottom.equalTo(self.contextView.safeAreaLayoutGuide).offset(offset)
            }
            UIView.animate(
                withDuration: 1.2,
                delay: 0.0, usingSpringWithDamping: 0.9,
                initialSpringVelocity: 0.7, options: .curveEaseOut,
                animations: {
                    self.superview?.layoutIfNeeded()
            }, completion: completion)
    }
    
    
    private func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
    
    // MARK: - Public Methods
    
    public static func make(in view: UIView, mainView: UIView, duration: Duration) -> Self {
        removeOldViews(form: view)
        return Self.init(contextView: view, mainView: mainView, duration: duration)
    }
    
    public func setAction(for actionButton:UIButton, action: (() -> Void)? = nil) -> SnackBarPresentable {
        actionButton.actionHandler(controlEvents: .touchUpInside) { [weak self] in
            self?.dismiss()
            action?()
        }
        
        return self
    }
    
    public func show() {
        constraintSuperView(with: contextView)
        animation(with: -CGFloat(style.padding)) { _ in
            
            if self.duration != .infinite {
            self.dismissTimer = Timer.init(
                timeInterval: TimeInterval(self.duration.value),
                target: self, selector: #selector(self.dismiss),
                userInfo: nil, repeats: false)
            RunLoop.main.add(self.dismissTimer!, forMode: .common)
            }
        }
        
    }
    
    @objc public func dismiss() {

        invalidDismissTimer()
        
        animation(with: 200, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
