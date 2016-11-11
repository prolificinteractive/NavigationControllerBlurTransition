# [DEPRECATED] NavigationControllerBlurTransition

⚠️ **This repository is no longer maintained or supported. New pull requests will not be reviewed.** ⚠️

[![Version](https://img.shields.io/cocoapods/v/NavigationControllerBlurTransition.svg?style=flat)](http://cocoapods.org/pods/NavigationControllerBlurTransition)
[![License](https://img.shields.io/cocoapods/l/NavigationControllerBlurTransition.svg?style=flat)](http://cocoapods.org/pods/NavigationControllerBlurTransition)
[![Platform](https://img.shields.io/cocoapods/p/NavigationControllerBlurTransition.svg?style=flat)](http://cocoapods.org/pods/NavigationControllerBlurTransition)

![alt tag](https://raw.githubusercontent.com/prolificinteractive/NavigationControllerBlurTransition/master/Images/screencap.gif)

NavigationControllerBlurTransition is a simple blur transition for your UINavigationController. With only one line of code, create a visually appealing interface for your app!

## Requirements

NavigationControllerBlurTransition utilizes UIVisualEffectView to provide its blur effect as well as dynamic frameworks (since the library is written in Swift); as such, it requires:

* iOS8+
* Xcode 7.0

## Installation

Add the following to your podfile: 


```ruby
pod "NavigationControllerBlurTransition"
```

## Usage

To use this transition, simply set your root view controller as the delegate for your UINavigationController, and implement the following `UINavigationControllerDelegate` delegate method as such:

```swift

func navigationController(navigationController: UINavigationController,
    animationControllerForOperation operation: UINavigationControllerOperation,
    fromViewController fromVC: UIViewController,
    toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
{
    return self.navigationController?.blurAnimationControllerForOperation(operation)
}

```

That's it! Now your view controller will push / pop its view controllers over a blurred representation of the initial view controller.

## Author

Christopher Jones, c.jones@prolificinteractive.com

## License

NavigationControllerBlurTransition is available under the MIT license. See the LICENSE file for more info.
