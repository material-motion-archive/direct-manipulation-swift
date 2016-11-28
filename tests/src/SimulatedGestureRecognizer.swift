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

/** A pan gesture recognizer that can simulate touch events. */
public class SimulatedPanGestureRecognizer: UIPanGestureRecognizer {
  public func simulateTouch(location: CGPoint? = nil, translation: CGPoint? = nil, state: UIGestureRecognizerState) {
    simulatedTranslation = translation
    proxy.simulateTouch(location: location, state: state, with: self)
  }

  private var proxy = GestureRecognizerProxy()

  public var targets: [AnyObject] {
    return proxy.targetActions.map { $0.target }
  }

  public var actions: [Selector] {
    return proxy.targetActions.map { $0.action }
  }

  private var simulatedTranslation: CGPoint?
  override public func translation(in view: UIView?) -> CGPoint {
    if let translation = simulatedTranslation {
      return translation
    }

    return CGPoint.zero
  }

  private var _state: UIGestureRecognizerState = .possible
  override public var state: UIGestureRecognizerState {
    get {
      return proxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override public func location(in view: UIView?) -> CGPoint {
    return proxy.location ?? super.location(in: view)
  }

  override public func addTarget(_ target: Any, action: Selector) {
    proxy.addTarget(target, action: action)
    super.addTarget(target, action: action)
  }
}

/** A pinch gesture recognizer that can simulate touch events. */
public class SimulatedPinchGestureRecognizer: UIPinchGestureRecognizer {
  public func simulateTouch(location: CGPoint? = nil, scale: CGFloat? = nil, state: UIGestureRecognizerState) {
    simulatedScale = scale
    proxy.simulateTouch(location: location, state: state, with: self)
  }

  private var proxy = GestureRecognizerProxy()

  public var targets: [AnyObject] {
    return proxy.targetActions.map { $0.target }
  }

  public var actions: [Selector] {
    return proxy.targetActions.map { $0.action }
  }

  private var simulatedScale: CGFloat?
  override public var scale: CGFloat {
    get {
      return simulatedScale ?? 1
    }
    set {
      simulatedScale = newValue
    }
  }

  private var _state: UIGestureRecognizerState = .possible
  override public var state: UIGestureRecognizerState {
    get {
      return proxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override public func location(in view: UIView?) -> CGPoint {
    return proxy.location ?? super.location(in: view)
  }

  override public func addTarget(_ target: Any, action: Selector) {
    proxy.addTarget(target, action: action)
    super.addTarget(target, action: action)
  }
}

/** A rotation gesture recognizer that can simulate touch events. */
public class SimulatedRotationGestureRecognizer: UIRotationGestureRecognizer {
  public func simulateTouch(location: CGPoint? = nil, rotation: CGFloat? = nil, state: UIGestureRecognizerState) {
    simulatedRotation = rotation
    proxy.simulateTouch(location: location, state: state, with: self)
  }

  private var proxy = GestureRecognizerProxy()

  public var targets: [AnyObject] {
    return proxy.targetActions.map { $0.target }
  }

  public var actions: [Selector] {
    return proxy.targetActions.map { $0.action }
  }

  private var simulatedRotation: CGFloat?
  override public var rotation: CGFloat {
    get {
      return simulatedRotation ?? 0
    }
    set {
      simulatedRotation = newValue
    }
  }

  private var _state: UIGestureRecognizerState = .possible
  override public var state: UIGestureRecognizerState {
    get {
      return proxy.state ?? _state
    }
    set {
      _state = newValue
    }
  }

  override public func location(in view: UIView?) -> CGPoint {
    return proxy.location ?? super.location(in: view)
  }

  override public func addTarget(_ target: Any, action: Selector) {
    proxy.addTarget(target, action: action)
    super.addTarget(target, action: action)
  }
}
