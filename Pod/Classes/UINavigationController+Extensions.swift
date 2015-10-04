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


private var blurAnimationControllerHandle: UInt8 = 0

public extension UINavigationController
{
    private var blurAnimationController: NavigationControllerBlurTransition {
        get {
            let blurAnimationController = objc_getAssociatedObject(self, &blurAnimationControllerHandle) as? NavigationControllerBlurTransition

            if let blurAnimationController = blurAnimationController {
                return blurAnimationController
            }

            let newAnimationController = NavigationControllerBlurTransition(navigationController: self)
            objc_setAssociatedObject(self,
                &blurAnimationControllerHandle,
                newAnimationController,
                .OBJC_ASSOCIATION_RETAIN)

            return newAnimationController
        }
    }

    /**
    Gathers the blur animation controller for this UINavigationController.

    - parameter operation: The navigation controller operation to occur.

    - returns: The blur animation controller.
    */
    public func blurAnimationControllerForOperation(operation: UINavigationControllerOperation) -> UIViewControllerAnimatedTransitioning
    {
        let animationController = self.blurAnimationController
        animationController.operation = operation

        return animationController
    }
}
