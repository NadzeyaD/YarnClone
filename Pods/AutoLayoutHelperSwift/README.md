[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/ustwo/autolayout-helper-swift/blob/master/LICENSE)
[![Build Status](https://travis-ci.org/ustwo/autolayout-helper-swift.svg?branch=master)](https://travis-ci.org/ustwo/autolayout-helper-swift)
[![codecov.io](https://codecov.io/github/ustwo/autolayout-helper-swift/coverage.svg?branch=master)](https://codecov.io/github/ustwo/autolayout-helper-swift?branch=master)

# AutoLayoutHelper

`UIView` extension to easily create common Auto Layout Constraints for iOS.

## The Problem

Using Auto Layout programatically (before [iOS 9's Auto Layout API](http://bartjacobs.com/auto-layout-fundamentals-working-with-layout-anchors/)) can either be quite verbose i.e. building `NSLayoutConstraint` objects for each rule or error prone e.g. (using [Visual Format Language strings](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/AutolayoutPG/VisualFormatLanguage/VisualFormatLanguage.html))

## A Solution

We can make creating common `NSLayoutConstraint` relations into some reusable methods we can call on any class that subclasses `UIView`. We also ensure the constraint created gets added to the view's superview for you.

This means you can relate a view to another view with the `NSLayoutAttribute` or `NSLayoutRelation` you need, as part of the view's setup and also helps us keep the code [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

## Dependencies

* [Xcode](https://itunes.apple.com/gb/app/xcode/id497799835?mt=12#)

## Requirements

* iOS 7+
* tvOS 9+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate AutoLayoutHelperSwift into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '8.3'

use_frameworks!

pod 'AutoLayoutHelperSwift', '~> 1.0.0'
```

Then, run the following command:

```bash
$ pod install
```

### Manually

- Add the `UIView+AutoLayoutHelper.swift` file to your Xcode project.
- **Note**. Dynamic Framework target coming soon!

## Usage

### Examples:

#### Fill Superview

Add `NSLayoutConstraint` relations for a `UIView` relating its top, leading, trailing and bottom edges to it's superview

    // Create view

    let leftView = UIView()
    leftView.backgroundColor = UIColor.red
    view.addSubview(leftView)

    // Add constraints

    leftView.addTopConstraint(toView: superview, attribute: .top, relation: .equal, constant: 10.0)
    leftView.addLeadingConstraint(toView: superview, attribute: .leading, relation: .equal, constant: 10.0)
    leftView.addTrailingConstraint(toView: superview, attribute: .trailing, relation: .equal, constant: -10.0)
    leftView.addBottomConstraint(toView: superview, attribute: .bottom, relation: .equal, constant: -10.0)

or shorter you can omit the attributes:

    leftView.addTopConstraint(toView: superview, constant: 10.0)
    leftView.addLeadingConstraint(toView: superview, constant: 10.0)
    leftView.addTrailingConstraint(toView: superview, constant: -10.0)
    leftView.addBottomConstraint(toView: superview, constant: -10.0)

or even shorter using `fillSuperView` (via [@danieladias](https://github.com/danieladias) )

    let edgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    leftView.fillSuperView(edgeInsets)

#### Centering

Add constraints to center a `UIView` within its superview both vertically (Y axis) and horizontally (X axis):

    label.addCenterXConstraintToView(label.superview, relation: .equal, constant:0.0)
    label.addCenterYConstraintToView(label.superview, relation: .equal, constant:0.0)

Add constraints for a fixed width and height amount:

    view.addWidthConstraintWithRelation: .equal, constant:100.0)
    view.addHeightConstraintWithRelation: .equal, constant:80.0)

Modify constraints (since the methods return them to you)

    // Create a reference to the `NSLayoutConstraint` e.g. for height

    heightConstraint = view.addHeightConstraint(toView: nil, constant: 80.0)

    ...

    // Update the height constant

    heightConstraint.constant = 30.0;

    // Animate changes

    UIView.animateWithDuration(0.3, animations: { () -> Void in

        view.layoutIfNeeded()
    })


## Contributing

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. See the [Code of Conduct](CODE_OF_CONDUCT.md) file

## Maintainers

* [Shagun Madhikarmi](mailto:shagun@ustwo.com)
* [Daniela Dias](mailto:daniela@ustwo.com)

## Contact

[open.source@ustwo.com](mailto:open.source@ustwo.com)

## License

AutoLayoutHelper is released under the MIT License. See [License](LICENSE).
