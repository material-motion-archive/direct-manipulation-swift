# Direct Manipulation for Material Motion (Swift)

[![Build Status](https://travis-ci.org/material-motion/direct-manipulation-swift.svg?branch=develop)](https://travis-ci.org/material-motion/direct-manipulation-swift)
[![codecov](https://codecov.io/gh/material-motion/direct-manipulation-swift/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-motion/direct-manipulation-swift)

## Supported languages

- Swift 3
- Objective-C

## Features

This library consists of the following plans:

- `Draggable`, `Pinchable`, and `Rotatable`
- `DirectlyManipulable`
- `ChangeAnchorPoint`

The `Draggable`, `Pinchable`, and `Rotatable` plans allow a user to move, scale, and rotate a view.
They each listen for deltas emitted by a gesture recognizer and add them to the target.

If a view can be dragged then it can sometimes be pinched and rotated too. To make this easy, we
provide a `DirectlyManipulable` plan. It's equivalent to individually adding `Draggable`,
`Pinchable`, and `Rotatable` to the same target.

The collection of `Draggable`, `Pinchable`, `Rotatable`, and `DirectlyManipulable` represent traits
that can describe behavior of a target view. When any of these traits are added to a view the view's
`isUserInteractionEnabled` is enabled. If the plan's associated gesture recognizer is not yet
associated with a view then the gesture recognizer will be added to the target view.

`ChangeAnchorPoint` adjusts `view.layer.anchorPoint` while maintaining the same `view.frame`. In
practice you will not use this plan directly because `Draggable`, `Pinchable`, and `Rotatable` each
provide the `shouldAdjustAnchorPointOnGestureStart` property for automatically emitting a
ChangeAnchorPoint instance.

## Installation

### Installation with CocoaPods

> CocoaPods is a dependency manager for Objective-C and Swift libraries. CocoaPods automates the
> process of using third-party libraries in your projects. See
> [the Getting Started guide](https://guides.cocoapods.org/using/getting-started.html) for more
> information. You can install it with the following command:
>
>     gem install cocoapods

Add `MaterialMotionDirectManipulation` to your `Podfile`:

    pod 'MaterialMotionDirectManipulation'

Then run the following command:

    pod install

### Usage

Import the framework:

    @import MaterialMotionDirectManipulation;

You will now have access to all of the APIs.

## Example apps/unit tests

Check out a local copy of the repo to access the Catalog application by running the following
commands:

    git clone https://github.com/material-motion/direct-manipulation-swift.git
    cd direct-manipulation-swift
    pod install
    open MaterialMotionDirectManipulation.xcworkspace

# Guides

1. [How to make a view directly manipulable](#how-to-make-a-view-directly-manipulable)
2. [How to make a view draggable](#how-to-make-a-view-draggable)
3. [How to use an existing gesture recognizer to make a view draggable](#how-to-use-an-existing-gesture-recognizer-to-make-a-view-draggable)

## How to make a view directly manipulable

Code snippets:

***In Objective-C:***

```objc
[runtime addPlan:[MDMDirectlyManipulable new] to:<#Object#>];
```

***In Swift:***

```swift
runtime.addPlan(DirectlyManipulable(), to: <#Object#>)
```

## How to make a view draggable

Code snippets:

***In Objective-C:***

```objc
[runtime addPlan:[MDMDraggable new] to:<#Object#>];
```

***In Swift:***

```swift
runtime.addPlan(Draggable(), to: <#Object#>)
```

## How to use an existing gesture recognizer to make a view draggable

Code snippets:

***In Objective-C:***

```objc
MDMDraggable *draggable = [[MDMDraggable alloc] initWithGestureRecognizer:panGestureRecognizer];
[runtime addPlan:draggable to:<#Object#>];
```

***In Swift:***

```swift
runtime.addPlan(Draggable(withGestureRecognizer: panGestureRecognizer), to: <#Object#>)
```

## Contributing

We welcome contributions!

Check out our [upcoming milestones](https://github.com/material-motion/direct-manipulation-swift/milestones).

Learn more about [our team](https://material-motion.github.io/material-motion/team/),
[our community](https://material-motion.github.io/material-motion/team/community/), and
our [contributor essentials](https://material-motion.github.io/material-motion/team/essentials/).

## License

Licensed under the Apache 2.0 license. See LICENSE for details.
