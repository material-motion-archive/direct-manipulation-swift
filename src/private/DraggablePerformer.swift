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
