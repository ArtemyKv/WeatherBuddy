//
//  PushAnimator.swift
//  WeatherBuddy
//
//  Created by Artem Kvashnin on 29.12.2022.
//

import Foundation
import UIKit

class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.5
    var originFrame = CGRect.zero
    var operation: UINavigationController.Operation = .push

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        if operation == .push {
            animatePush(using: transitionContext, fromView: fromView, toView: toView)
        } else if operation == .pop {
            animatePop(using: transitionContext, fromView: fromView, toView: toView)
        }
    }
    
    func animatePush(using transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let safeAreaTopInset = fromView.safeAreaInsets.top
        let initialFrame = originFrame
        let finalFrame = toView.frame
        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        toView.transform = scaleTransform
        toView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY + safeAreaTopInset)
        toView.alpha = 0.0
        toView.layer.cornerRadius = 20.0
        
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: [.curveEaseIn],
                       animations: {
            toView.transform = CGAffineTransform.identity
            toView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            toView.alpha = 1.0
            toView.layer.cornerRadius = 0.0
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    func animatePop(using transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let xScaleFactor = (originFrame.width / fromView.frame.width) / 4
        let yScaleFactor = (originFrame.height / fromView.frame.height) / 4
        
        transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
            fromView.transform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            fromView.alpha = 0.0
            fromView.layer.cornerRadius = 20.0
            
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
