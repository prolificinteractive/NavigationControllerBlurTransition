//Copyright (c) 2015 Prolific Interactive.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.


/// A navigation controller animation that blurs out the backing view as the destination view animates in normally
/// On push, the destination view controller should be designed to expect a clear background as it will automatically
/// be made clear.
internal class NavigationControllerBlurTransition: NSObject, UIViewControllerAnimatedTransitioning
{
    /// The operation to perform. This should be set before beginning the transition
    /// Setting this to none is considered undefined behavior and will cause a fatalError
    internal var operation = UINavigationControllerOperation.None
    
    private var blurTransitionContainerView = UIView()
    
    private var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark))
    
    private weak var navigationController: UINavigationController?
    
    /**
    Initializes a new instance using the input navigation controller.
    
    - parameter navigationController: The navigation controller.
    */
    internal init(navigationController: UINavigationController)
    {
        self.navigationController = navigationController
    }
    
    internal func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        guard let containerView = transitionContext.containerView() else {
            fatalError("Container view or destination view not found for UINavigationControllerBlurTransition")
        }
        
        if self.operation == .Push {
            self.performPushTransition(containerView,
                context: transitionContext)
        } else if self.operation == .Pop {
            self.performPopTransition(containerView,
                context: transitionContext)
        } else {
            fatalError("Cannot perform a UINavigationControllerBlurTransition with UINavigationControllerOperation.None")
        }
    }

    internal func animationEnded(transitionCompleted: Bool)
    {

    }

    internal func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval
    {
        return 0.3
    }

    
    private func performPushTransition(containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        guard let fromView = context.viewForKey(UITransitionContextFromViewKey),
            let destinationView = context.viewForKey(UITransitionContextToViewKey) else {
                return
        }
        
        if self.blurTransitionContainerView.superview == nil {
            self.performInitialPush(fromView,
                destinationView: destinationView,
                containerView: containerView,
                context: context)
        } else {
            self.performPushOntoExistingBlurView(fromView,
                destinationView: destinationView,
                containerView: containerView,
                context: context)
        }
    }
    
    private func performInitialPush(fromView: UIView,
        destinationView: UIView,
        containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        self.blurTransitionContainerView.addSubview(fromView)
        self.blurTransitionContainerView.addSubview(self.blurView)
        self.blurView.alpha = 0
        
        containerView.addSubview(self.blurTransitionContainerView)

        self.blurView.makeEdgesEqualTo(containerView)

        destinationView.backgroundColor = UIColor.clearColor()
        containerView.addSubview(destinationView)
        
        self.blurView.setNeedsLayout()
        self.blurView.layoutIfNeeded()

        destinationView.makeConstraintsToRightOfView(containerView)
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        self.performAnimationInContext(context, animations: { () -> Void in
            self.blurView.alpha = 1

            destinationView.removeInstalledConstraints()
            
            destinationView.makeEdgesEqualTo(containerView)
            
            containerView.layoutIfNeeded()
            }, completion: {
                self.blurTransitionContainerView.addSubview(fromView)
                self.blurTransitionContainerView.sendSubviewToBack(fromView)
        })
    }
    
    private func performPushOntoExistingBlurView(fromView: UIView,
        destinationView: UIView,
        containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        destinationView.backgroundColor = UIColor.clearColor()
        
        containerView.addSubview(self.blurTransitionContainerView)
        containerView.addSubview(fromView)
        containerView.addSubview(destinationView)

        destinationView.makeConstraintsToRightOfView(containerView)
        
        containerView.layoutIfNeeded()
        
        self.performAnimationInContext(context, animations: {
            destinationView.removeInstalledConstraints()
            destinationView.makeEdgesEqualTo(containerView)
            
            containerView.layoutIfNeeded()
            
            fromView.alpha = 0.0
        })
    }
    
    private func performPopTransition(containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        guard let fromView = context.viewForKey(UITransitionContextToViewKey),
            let destinationView = context.viewForKey(UITransitionContextFromViewKey) else {
                return
        }
        
        let toViewController = context.viewControllerForKey(UITransitionContextToViewControllerKey)
        if toViewController == self.navigationController?.viewControllers.first {
            self.performPopTransitionToRootViewController(fromView,
                destinationView: destinationView,
                containerView: containerView,
                context: context)
        } else {
            self.performPopTransitionToPreviousViewController(fromView,
                destinationView: destinationView,
                containerView: containerView,
                context: context)
        }
    }
    
    private func performPopTransitionToRootViewController(fromView: UIView,
        destinationView: UIView,
        containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        containerView.addSubview(fromView)
        containerView.sendSubviewToBack(fromView)
        
        self.performAnimationInContext(context, animations: { () -> Void in
            destinationView.removeInstalledConstraints()
            destinationView.makeConstraintsToRightOfView(containerView)

            containerView.layoutIfNeeded()
            self.blurView.alpha = 0.0
            
            }, completion: {
                self.blurTransitionContainerView.removeFromSuperview()
        })
    }
    
    private func performPopTransitionToPreviousViewController(fromView: UIView,
        destinationView: UIView,
        containerView: UIView,
        context: UIViewControllerContextTransitioning)
    {
        containerView.addSubview(self.blurTransitionContainerView)
        containerView.addSubview(fromView)
        containerView.addSubview(destinationView)

        fromView.makeEdgesEqualTo(containerView)

        containerView.layoutIfNeeded()
        
        fromView.alpha = 0.0
        
        self.performAnimationInContext(context, animations: { () -> Void in
            destinationView.removeInstalledConstraints()
            destinationView.makeConstraintsToRightOfView(containerView)
            
            containerView.layoutIfNeeded()
            
            fromView.alpha = 1.0
        })
    }

    private func performAnimationInContext(context: UIViewControllerContextTransitioning,
        animations: () -> Void,
        completion: (() -> Void)? = nil)
    {
        UIView.animateWithDuration(0.3, animations: {
            animations()
            },
            completion: { finished in
                context.completeTransition(finished)
                completion?()
        })
    }
}