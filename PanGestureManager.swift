//
//  PanGestureManager.swift
//  PanGestureTool
//
//  Created by Heng.Wang on 2021/5/10.
//

import Foundation
import UIKit
 
class PanGestureManager {
    
    enum Direction {
        case Horizontal_FEFT
        case Horizontal_RIGHT
        case Vertical
    }
    
    static let shared = PanGestureManager()
    
    fileprivate var controller: UIViewController?
    fileprivate var view      : UIView?
    fileprivate var direction : Direction = .Vertical
    fileprivate var viewWidth : CGFloat = 0.0
    fileprivate var viewTranslation = CGPoint(x: 0, y: 0)
     
}


//MARK:- Pan viewcontroller
extension PanGestureManager {
    public func dragVC(_ controller: UIViewController?, _ direction: Direction) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(_:)))
        
        guard let controller = controller else { return }
        self.view = nil
        self.direction = direction
        self.controller = controller
        self.controller?.view.addGestureRecognizer(pan)
        self.viewWidth = controller.view.bounds.width
    }
    
    @objc fileprivate func handleDismiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: controller?.view)
            
            #if DEBUG
            print("viewTranslation Y: \(viewTranslation.y)")
            print("viewTranslation X: \(viewTranslation.x)")
            #endif
            if direction == .Vertical {
                if viewTranslation.y > 0 {
                    animate( CGAffineTransform(translationX: 0, y: self.viewTranslation.y))
                }
            } else {
                if direction == .Horizontal_RIGHT {
                    if viewTranslation.x < 0 {
                        animate(CGAffineTransform(translationX: self.viewTranslation.x, y: 0))
                    }
                } else {
                    if viewTranslation.x > 0 {
                        animate(CGAffineTransform(translationX: self.viewTranslation.x, y: 0))
                    }
                }
            }
        case .ended:
            if direction == .Vertical {
                if viewTranslation.y < 200 {
                    animate(.identity)
                } else {
                    dismissVC()
                }
            } else {
                if direction == .Horizontal_RIGHT {
                    if viewTranslation.x > -viewWidth / 2 {
                        animate(.identity)
                    } else {
                        self.controller?.modalTransitionStyle = .crossDissolve
                        dismissVC()
                    }
                } else {
                    if viewTranslation.x < (viewWidth / 3) * 2 {
                        animate(.identity)
                    } else {
                        self.controller?.modalTransitionStyle = .crossDissolve
                        dismissVC()
                    }
                }
            }
        default: break
        }
    }
}


//MARK:- Pan view
extension PanGestureManager {
    public func dragView(_ controller: UIViewController?, view: UIView?, _ direction: Direction) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewHandleDismiss(_:)))
        
        
        guard let controller = controller,
              let view = view
              else { return }
        self.direction = direction
        self.view = view
        self.controller = controller
        self.controller?.view.addGestureRecognizer(pan)
        self.viewWidth = controller.view.bounds.width
    }
    
    @objc fileprivate func viewHandleDismiss(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            viewTranslation = sender.translation(in: controller?.view)
            
            #if DEBUG
            print("viewTranslation Y: \(viewTranslation.y)")
            print("viewTranslation X: \(viewTranslation.x)")
            #endif
            if direction == .Vertical {
                if viewTranslation.y > 0 {
                    viewAnimate( CGAffineTransform(translationX: 0, y: self.viewTranslation.y))
                }
            } else {
                if direction == .Horizontal_RIGHT {
                    if viewTranslation.x < 0 {
                        viewAnimate(CGAffineTransform(translationX: self.viewTranslation.x, y: 0))
                    }
                } else {
                    if viewTranslation.x > 0 {
                        viewAnimate(CGAffineTransform(translationX: self.viewTranslation.x, y: 0))
                    }
                }
            }
        case .ended:
            if direction == .Vertical {
                if viewTranslation.y < 200 {
                    viewAnimate(.identity)
                } else {
                    dismissVC()
                }
            } else {
                if direction == .Horizontal_RIGHT {
                    if viewTranslation.x > -viewWidth / 2 {
                        viewAnimate(.identity)
                    } else {
                        self.controller?.modalTransitionStyle = .crossDissolve
                        dismissVC()
                    }
                } else {
                    if viewTranslation.x < (viewWidth / 3) * 2 {
                        viewAnimate(.identity)
                    } else {
                        self.controller?.modalTransitionStyle = .crossDissolve
                        dismissVC()
                    }
                }
            }
        default: break
        }
    }
}


//MARK:- Action
extension PanGestureManager {
    fileprivate func animate(_ cGAffineTransform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.controller?.view.transform = cGAffineTransform
        } completion: { (_) in }
    }
     
    fileprivate func viewAnimate(_ cGAffineTransform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view?.transform = cGAffineTransform
        } completion: { (_) in }
    }
    
    fileprivate func dismissVC() {
        self.controller?.dismiss(animated: true, completion: nil)
        self.view = nil
        self.controller = nil
    }
}
