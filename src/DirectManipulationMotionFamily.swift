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

/// A plan that enables a target to be dragged.
public final class Draggable: NSObject, Plan {
  public let panGestureRecognizer: UIPanGestureRecognizer

  public init(withGestureRecognizer recognizer: UIPanGestureRecognizer = UIPanGestureRecognizer()) {
    self.panGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return DraggablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return Draggable(withGestureRecognizer: panGestureRecognizer)
  }
}

/// A gesture performer that enables its target to be dragged.
final class DraggablePerformer: NSObject, PlanPerforming {
  let target: UIView

  private var previousTranslation = CGPoint.zero

  required init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func add(plan: Plan) {
    guard let plan = plan as? Draggable else {
      fatalError("DraggablePerformer can only add Draggable plans.")
    }

    let recognizer = plan.panGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }
  }

  func handle(gesture: UIPanGestureRecognizer) {
    var translation = gesture.translation(in: target)

    if gesture.state == .began {
      previousTranslation = CGPoint.zero
    }

    var originalTranslation = translation
    translation.x -= previousTranslation.x
    translation.y -= previousTranslation.y
    previousTranslation = originalTranslation

    target.transform = target.transform.translatedBy(x: translation.x, y: translation.y)
  }
}

/// A plan that enables a target to be scaled by pinching.
public final class Pinchable: NSObject, Plan {
  public let pinchGestureRecognizer: UIPinchGestureRecognizer

  public init(withGestureRecognizer recognizer: UIPinchGestureRecognizer = UIPinchGestureRecognizer()) {
    self.pinchGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return PinchablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return Pinchable(withGestureRecognizer: pinchGestureRecognizer)
  }
}

/// A gesture performer that enables its target to be scaled by pinching.
private final class PinchablePerformer: NSObject, PlanPerforming {
  let target: UIView

  private var previousScale: CGFloat = 1

  required init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func add(plan: Plan) {
    guard let plan = plan as? Pinchable else {
      fatalError("DraggablePerformer can only add Draggable plans.")
    }

    let recognizer = plan.pinchGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }
  }

  func handle(gesture: UIPinchGestureRecognizer) {
    if gesture.state == .began {
      previousScale = 1
    }

    let newScale = 1 + (gesture.scale - previousScale)
    target.transform = target.transform.scaledBy(x: newScale, y: newScale)
    previousScale = gesture.scale
  }
}

/// A plan that enables a target to be rotated using a two-finger rotation gesture.
public final class Rotatable: NSObject, Plan {
  public let rotationGestureRecognizer: UIRotationGestureRecognizer

  public init(withGestureRecognizer recognizer: UIRotationGestureRecognizer = UIRotationGestureRecognizer()) {
    self.rotationGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return RotatablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return Rotatable(withGestureRecognizer: rotationGestureRecognizer)
  }
}

/// A gesture performer that enables its target to be rotated using a two-finger rotation gesture.
private final class RotatablePerformer: NSObject, PlanPerforming {
  let target: UIView

  private var previousRotation: CGFloat = 0

  required init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func add(plan: Plan) {
    guard let plan = plan as? Rotatable else {
      fatalError("RotatablePerformer can only add Rotatable plans.")
    }

    let recognizer = plan.rotationGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }
  }

  func handle(gesture: UIGestureRecognizer) {
    guard let gesture = gesture as? UIRotationGestureRecognizer else { return }

    if gesture.state == .began {
      previousRotation = 0
    }

    let rotation = gesture.rotation - previousRotation
    target.transform = target.transform.rotated(by: rotation)
    previousRotation = gesture.rotation
  }
}

/// A plan that enables its target to be dragged, pinched and rotated simultaneously.
public final class DirectlyManipulable: NSObject, Plan {
  public var panGestureRecognizer: UIPanGestureRecognizer {
    return draggable.panGestureRecognizer
  }
  public var pinchGestureRecognizer: UIPinchGestureRecognizer {
    return pinchable.pinchGestureRecognizer
  }
  public var rotationGestureRecognizer: UIRotationGestureRecognizer {
    return rotatable.rotationGestureRecognizer
  }

  fileprivate let draggable: Draggable
  fileprivate let pinchable: Pinchable
  fileprivate let rotatable: Rotatable

  public override convenience init() {
    self.init(draggable: Draggable(), pinchable: Pinchable(), rotatable: Rotatable())
  }

  /// A private init to assist in making copies
  ///
  /// Note that we can't provide defaults for the parameters,
  /// else it will collide with the convenience init()
  private init(draggable: Draggable, pinchable: Pinchable, rotatable: Rotatable) {
    self.draggable = draggable
    self.pinchable = pinchable
    self.rotatable = rotatable
    super.init()
  }

  public func performerClass() -> AnyClass {
    return DirectlyManipulablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return DirectlyManipulable(draggable: draggable, pinchable: pinchable, rotatable: rotatable)
  }
}

final class DirectlyManipulablePerformer: NSObject, PlanPerforming, ComposablePerforming {
  let target: UIView

  fileprivate var gestureRecognizers: [UIGestureRecognizer] = []

  required init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func add(plan: Plan) {
    guard let plan = plan as? DirectlyManipulable else {
      fatalError("DirectlyManipulablePerformer can only add DirectlyManipulable plans.")
    }

    gestureRecognizers = [
      plan.draggable.panGestureRecognizer,
      plan.pinchable.pinchGestureRecognizer,
      plan.rotatable.rotationGestureRecognizer
    ]

    let transaction = Transaction()
    transaction.add(plan: plan.draggable, to: target)
    transaction.add(plan: plan.pinchable, to: target)
    transaction.add(plan: plan.rotatable, to: target)

    // Set ourselves as each recognizer's delegate, if possible,
    // in order to allow simultaneous recognition
    for recognizer in gestureRecognizers {
        if recognizer.delegate == nil {
          recognizer.delegate = self
        }
    }

    emitter.emit(transaction: transaction)
  }

  private var emitter: TransactionEmitting!

  func set(transactionEmitter: TransactionEmitting) {
    emitter = transactionEmitter
  }
}

extension DirectlyManipulablePerformer: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    /// Allow the performer's gesture recognizers to recognizer simultaneously
    return gestureRecognizers.contains(otherGestureRecognizer)
  }
}
