/*
 Copyright 2016-present The Material Motion Authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import UIKit
import MaterialMotionRuntime

/// Testing technique borrowed from: http://vojtastavik.com/2016/03/30/testing-gesture-recognizers/

/// A proxy object that allows simulating touch events
class TestableGestureRecognizerProxy {

  fileprivate class TargetAction {
    let target: AnyObject
    let action: Selector

    init(target: AnyObject, action: Selector) {
      self.target = target
      self.action = action
    }
  }

  fileprivate var targetActions: [TargetAction] = []

  var state: UIGestureRecognizerState?
  var location: CGPoint?

  fileprivate func addTarget(_ target: Any, action: Selector) {
    let targetAction = TargetAction(target: target as AnyObject, action: action)
    targetActions.append(targetAction)
  }

  fileprivate func performTouch(location: CGPoint? = nil, state: UIGestureRecognizerState, with gestureRecognizer: UIGestureRecognizer) {
    self.location = location
    self.state = state

    for targetAction in targetActions {
      targetAction.target.performSelector(onMainThread: targetAction.action, with: gestureRecognizer, waitUntilDone: true)
    }
  }
}

/// A pan gesture recognizer that facilitates testing through a proxy object
class TestablePanGestureRecognizer: UIPanGestureRecognizer {
  fileprivate var testProxy = TestableGestureRecognizerProxy()

  var targets: [AnyObject] {
    return testProxy.targetActions.map { $0.target }
  }

  var actions: [Selector] {
    return testProxy.targetActions.map { $0.action }
  }

  private var testTranslation: CGPoint?

  override func translation(in view: UIView?) -> CGPoint {
    if let translation = testTranslation {
      return translation
    }

    return CGPoint.zero
  }

  private var _state: UIGestureRecognizerState = .possible
  override var state: UIGestureRecognizerState {
    get {
      return testProxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override func location(in view: UIView?) -> CGPoint {
    return testProxy.location ?? super.location(in: view)
  }

  override func addTarget(_ target: Any, action: Selector) {
    testProxy.addTarget(target, action: action)

    super.addTarget(target, action: action)
  }

  func performTouch(location: CGPoint? = nil, translation: CGPoint? = nil, state: UIGestureRecognizerState) {
    testTranslation = translation
    testProxy.performTouch(location: location, state: state, with: self)
  }
}

/// A pinch gesture recognizer that facilitates testing through a proxy object
class TestablePinchGestureRecognizer: UIPinchGestureRecognizer {
  fileprivate var testProxy = TestableGestureRecognizerProxy()

  var targets: [AnyObject] {
    return testProxy.targetActions.map { $0.target }
  }

  var actions: [Selector] {
    return testProxy.targetActions.map { $0.action }
  }

  private var testScale: CGFloat?

  private var _scale: CGFloat = 1
  override var scale: CGFloat {
    get {
      return testScale ?? _scale
    }
    set {
      _scale = newValue
    }
  }

  private var _state: UIGestureRecognizerState = .possible
  override var state: UIGestureRecognizerState {
    get {
      return testProxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override func location(in view: UIView?) -> CGPoint {
    return testProxy.location ?? super.location(in: view)
  }

  override func addTarget(_ target: Any, action: Selector) {
    testProxy.addTarget(target, action: action)

    super.addTarget(target, action: action)
  }

  func performTouch(location: CGPoint? = nil, scale: CGFloat? = nil, state: UIGestureRecognizerState) {
    testScale = scale
    testProxy.performTouch(location: location, state: state, with: self)
  }
}

/// A rotation gesture recognizer that facilitates testing through a proxy object
class TestableRotationGestureRecognizer: UIRotationGestureRecognizer {
  fileprivate var testProxy = TestableGestureRecognizerProxy()

  var targets: [AnyObject] {
    return testProxy.targetActions.map { $0.target }
  }

  var actions: [Selector] {
    return testProxy.targetActions.map { $0.action }
  }

  private var testRotation: CGFloat?

  private var _rotation: CGFloat = 0
  override var rotation: CGFloat {
    get {
      return testRotation ?? _rotation
    }
    set {
      _rotation = newValue
    }
  }

  private var _state: UIGestureRecognizerState = .possible
  override var state: UIGestureRecognizerState {
    get {
      return testProxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override func location(in view: UIView?) -> CGPoint {
    return testProxy.location ?? super.location(in: view)
  }

  override func addTarget(_ target: Any, action: Selector) {
    testProxy.addTarget(target, action: action)

    super.addTarget(target, action: action)
  }

  func performTouch(location: CGPoint? = nil, rotation: CGFloat? = nil, state: UIGestureRecognizerState) {
    testRotation = rotation
    testProxy.performTouch(location: location, state: state, with: self)
  }
}
