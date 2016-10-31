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

/**
 A plan that enables a target to be dragged.

 Enables isUserInteractionEnabled on the target view.
 */
@objc(MDMDraggable)
public final class Draggable: NSObject, Plan {
  public let panGestureRecognizer: UIPanGestureRecognizer
  public var shouldAdjustAnchorPointOnGestureStart = false

  public convenience override init() {
    self.init(withGestureRecognizer: UIPanGestureRecognizer())
  }

  public init(withGestureRecognizer recognizer: UIPanGestureRecognizer) {
    self.panGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return DraggablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    let draggable = Draggable(withGestureRecognizer: panGestureRecognizer)
    draggable.shouldAdjustAnchorPointOnGestureStart = shouldAdjustAnchorPointOnGestureStart
    return draggable
  }
}

/// A gesture performer that enables its target to be dragged.
final class DraggablePerformer: NSObject, PlanPerforming, ComposablePerforming {
  let target: UIView

  private var previousTranslation = CGPoint.zero

  required init(target: Any) {
    self.target = target as! UIView
    self.target.isUserInteractionEnabled = true
    super.init()
  }

  func addPlan(_ plan: Plan) {
    guard let plan = plan as? Draggable else {
      fatalError("DraggablePerformer can only add Draggable plans.")
    }

    let recognizer = plan.panGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }

    if plan.shouldAdjustAnchorPointOnGestureStart {
      recognizer.addTarget(self, action: #selector(modifyAnchorPoint(using:)))
    }
  }

  func handle(gesture: UIPanGestureRecognizer) {
    var translation = gesture.translation(in: target.superview)

    if gesture.state == .began {
      previousTranslation = CGPoint.zero
    }

    var originalTranslation = translation
    translation.x -= previousTranslation.x
    translation.y -= previousTranslation.y
    previousTranslation = originalTranslation

    target.center.x += translation.x
    target.center.y += translation.y
  }

  func modifyAnchorPoint(using gesture: UIGestureRecognizer) {
    if gesture.state != .began { return }

    let transaction = makeAnchorPointAdjustmentTransaction(using: gesture, on: target)
    emitter.emit(transaction: transaction)
  }

  /// Emitter setup
  fileprivate var emitter: TransactionEmitting!

  func set(transactionEmitter: TransactionEmitting) {
    emitter = transactionEmitter
  }
}

/**
 A plan that enables a target to be scaled by pinching.

 Enables isUserInteractionEnabled on the target view.
 */
@objc(MDMPinchable)
public final class Pinchable: NSObject, Plan {
  public let pinchGestureRecognizer: UIPinchGestureRecognizer
  public var shouldAdjustAnchorPointOnGestureStart = true

  public convenience override init() {
    self.init(withGestureRecognizer: UIPinchGestureRecognizer())
  }

  public init(withGestureRecognizer recognizer: UIPinchGestureRecognizer) {
    self.pinchGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return PinchablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    let pinchable = Pinchable(withGestureRecognizer: pinchGestureRecognizer)
    pinchable.shouldAdjustAnchorPointOnGestureStart = shouldAdjustAnchorPointOnGestureStart
    return pinchable
  }
}

/// A gesture performer that enables its target to be scaled by pinching.
final class PinchablePerformer: NSObject, PlanPerforming, ComposablePerforming {
  let target: UIView

  private var previousScale: CGFloat = 1

  required init(target: Any) {
    self.target = target as! UIView
    self.target.isUserInteractionEnabled = true
    super.init()
  }

  func addPlan(_ plan: Plan) {
    guard let plan = plan as? Pinchable else {
      fatalError("PinchablePerformer can only add Pinchable plans.")
    }

    let recognizer = plan.pinchGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }

    if plan.shouldAdjustAnchorPointOnGestureStart {
      recognizer.addTarget(self, action: #selector(modifyAnchorPoint(using:)))
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

  func modifyAnchorPoint(using gesture: UIGestureRecognizer) {
    if gesture.state != .began { return }

    let transaction = makeAnchorPointAdjustmentTransaction(using: gesture, on: target)
    emitter.emit(transaction: transaction)
  }

  /// Emitter setup
  fileprivate var emitter: TransactionEmitting!

  func set(transactionEmitter: TransactionEmitting) {
    emitter = transactionEmitter
  }
}

/**
 A plan that enables a target to be rotated using a two-finger rotation gesture.

 Enables isUserInteractionEnabled on the target view.
 */
@objc(MDMRotatable)
public final class Rotatable: NSObject, Plan {
  public let rotationGestureRecognizer: UIRotationGestureRecognizer
  public var shouldAdjustAnchorPointOnGestureStart = true

  public convenience override init() {
    self.init(withGestureRecognizer: UIRotationGestureRecognizer())
  }

  public init(withGestureRecognizer recognizer: UIRotationGestureRecognizer) {
    self.rotationGestureRecognizer = recognizer
    super.init()
  }

  public func performerClass() -> AnyClass {
    return RotatablePerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    let rotatable = Rotatable(withGestureRecognizer: rotationGestureRecognizer)
    rotatable.shouldAdjustAnchorPointOnGestureStart = shouldAdjustAnchorPointOnGestureStart
    return rotatable
  }
}

/// A gesture performer that enables its target to be rotated using a two-finger rotation gesture.
final class RotatablePerformer: NSObject, PlanPerforming, ComposablePerforming {
  let target: UIView

  private var previousRotation: CGFloat = 0

  required init(target: Any) {
    self.target = target as! UIView
    self.target.isUserInteractionEnabled = true
    super.init()
  }

  func addPlan(_ plan: Plan) {
    guard let plan = plan as? Rotatable else {
      fatalError("RotatablePerformer can only add Rotatable plans.")
    }

    let recognizer = plan.rotationGestureRecognizer
    recognizer.addTarget(self, action: #selector(handle(gesture:)))

    if recognizer.view == nil {
      target.addGestureRecognizer(recognizer)
    }

    if plan.shouldAdjustAnchorPointOnGestureStart {
      recognizer.addTarget(self, action: #selector(modifyAnchorPoint(using:)))
    }
  }

  func handle(gesture: UIGestureRecognizer) {
    guard let gesture = gesture as? UIRotationGestureRecognizer else { return }

    // Apply transform
    if gesture.state == .began {
      previousRotation = 0
    }

    let rotation = gesture.rotation - previousRotation
    target.transform = target.transform.rotated(by: rotation)
    previousRotation = gesture.rotation
  }

  func modifyAnchorPoint(using gesture: UIGestureRecognizer) {
    if gesture.state != .began { return }

    let transaction = makeAnchorPointAdjustmentTransaction(using: gesture, on: target)
    emitter.emit(transaction: transaction)
  }

  /// Emitter setup
  fileprivate var emitter: TransactionEmitting!

  func set(transactionEmitter: TransactionEmitting) {
    emitter = transactionEmitter
  }

}

// MARK: - Directly Manipulable

/**
 A plan that enables its target to be dragged, pinched and rotated simultaneously.

 Enables isUserInteractionEnabled on the target view.
 */
@objc(MDMDirectlyManipulable)
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

  /// Initializes a DirectlyManipulable plan using user-provided subplans, if provided.
  public convenience override init() {
    self.init(draggable: Draggable(), pinchable: Pinchable(), rotatable: Rotatable())
  }

  public init(draggable: Draggable, pinchable: Pinchable, rotatable: Rotatable) {
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
    self.target.isUserInteractionEnabled = true
    super.init()
  }

  func addPlan(_ plan: Plan) {
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

    for recognizer in gestureRecognizers {
      // Set ourselves as each recognizer's delegate, if possible,
      // in order to allow simultaneous recognition
      if recognizer.delegate == nil {
        recognizer.delegate = self
      }
    }

    emitter.emit(transaction: transaction)
  }

  /// Emitter setup
  fileprivate var emitter: TransactionEmitting!

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

// MARK: - Anchor Point Handling

/// A plan that modifies the anchor point of its target
@objc(MDMChangeAnchorPoint)
public final class ChangeAnchorPoint: NSObject, Plan {
  let anchorPoint: CGPoint

  public init(withAnchorPoint anchorPoint: CGPoint) {
    self.anchorPoint = anchorPoint
    super.init()
  }

  public func performerClass() -> AnyClass {
    return AnchorPointPerformer.self
  }

  public func copy(with zone: NSZone? = nil) -> Any {
    return ChangeAnchorPoint(withAnchorPoint: anchorPoint)
  }
}

final class AnchorPointPerformer: NSObject, PlanPerforming {
  let target: UIView

  init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func addPlan(_ plan: Plan) {
    guard let plan = plan as? ChangeAnchorPoint else {
      fatalError("AnchorPointPerformer can only add ChangeAnchorPoint plans.")
    }

    let newPosition = CGPoint(x: plan.anchorPoint.x * target.layer.bounds.width,
                              y: plan.anchorPoint.y * target.layer.bounds.height)

    let positionInSuperview = target.convert(newPosition, to: target.superview)

    target.layer.anchorPoint = plan.anchorPoint
    target.layer.position = positionInSuperview
  }
}

/// Creates and returns a Transaction consisting of a ChangeAnchorPoint plan.
///
/// - Parameter gestureRecognizer: Recognizer used to determine touch location
/// - Parameter target: The view that will have its anchor point changed
///
/// - Returns: A Transaction consisting of a ChangeAnchorPoint plan
private func makeAnchorPointAdjustmentTransaction(using gestureRecognizer: UIGestureRecognizer, on target: UIView) -> Transaction {
  // Determine the new anchor point
  let locationInView = gestureRecognizer.location(in: target)
  let anchorPoint = CGPoint(x: locationInView.x / target.bounds.width, y: locationInView.y / target.bounds.height)

  // Create a transaction around the ChangeAnchorPoint plan
  let transaction = Transaction()
  transaction.add(plan: ChangeAnchorPoint(withAnchorPoint: anchorPoint), to: target)

  return transaction
}
