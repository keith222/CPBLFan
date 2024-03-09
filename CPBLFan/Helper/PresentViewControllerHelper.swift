//
//  PresentViewControllerHelper.swift
//  CPBLFan
//
//  Created by Yang Tun-Kai on 2020/1/27.
//  Copyright © 2020 Sparkr. All rights reserved.
//

import Foundation
import UIKit

class PresentViewControllerHelper: NSObject, UIViewControllerAnimatedTransitioning {
    
    var dismissCompletion: (() -> Void)?
    var originFrame: CGRect = .zero
    var duration: TimeInterval = 0.0
    var isVideo: Bool = false
    var presenting: Bool = true {
        didSet {
            self.duration = presenting ? 0.55 : 0.5
        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let recipeView = self.presenting ? toView : transitionContext.view(forKey: .from)!
        let initialFrame = presenting ? originFrame : recipeView.frame
        let finalFrame = presenting ? recipeView.frame : originFrame

        if self.presenting {
            let xScaleFactor = initialFrame.width / finalFrame.width
            let yScaleFactor = initialFrame.height / finalFrame.height
            let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
            recipeView.transform = scaleTransform
            recipeView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            recipeView.clipsToBounds = true
        }
                
        recipeView.layer.cornerRadius = presenting ? 20.0 : 0.0
        recipeView.layer.masksToBounds = true

        containerView.addSubview(toView)
        containerView.bringSubviewToFront(recipeView)

        let animator = UIViewPropertyAnimator(duration: self.duration, dampingRatio: 0.8, animations: { [weak self] in
            recipeView.transform = .identity
            recipeView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            recipeView.layer.cornerRadius = !(self?.presenting ?? true) ? 20.0 : 0.0
            
            if !(self?.presenting ?? true) {
                recipeView.frame = finalFrame
                
                if (self?.isVideo ?? false) {
                    recipeView.alpha = 0
                }
            }
        })
        animator.startAnimation()
        animator.addCompletion({ [weak self] finished in
            if !(self?.presenting ?? true) {
                self?.dismissCompletion?()
            }

            transitionContext.completeTransition(true)
        })
    }
}
