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

final class GesturePerformer: NSObject, ContinuousPerforming, ComposablePerforming {
  let target: UIView

  private var previousTranslation = CGPoint.zero
  private var previousScale: CGFloat = 1
  private var previousRotation: CGFloat = 0

  required init(target: Any) {
    self.target = target as! UIView
    self.target.isUserInteractionEnabled = true
    super.init()
  }

  var gestureTokens: [UIGestureRecognizer: IsActiveTokenable] = [:]
  func addPlan(_ plan: Plan) {
    let plan = plan as! Gesturable
    let gestureRecognizer = plan.gestureRecognizer
    let shouldAdjustAnchorPoint = plan.shouldAdjustAnchorPointOnGestureStart

    switch gestureRecognizer {
    case is UIPanGestureRecognizer:
      gestureRecognizer.addTarget(self, action: #selector(handle(panGesture:)))
    case is UIRotationGestureRecognizer:
      gestureRecognizer.addTarget(self, action: #selector(handle(rotationGesture:)))
    case is UIPinchGestureRecognizer:
      gestureRecognizer.addTarget(self, action: #selector(handle(pinchGesture:)))
    default: ()
    }

    gestureRecognizer.addTarget(self, action: #selector(handle(gesture:)))

    if gestureRecognizer.view == nil {
      target.addGestureRecognizer(gestureRecognizer)
    }

    if shouldAdjustAnchorPoint {
      gestureRecognizer.addTarget(self, action: #selector(modifyAnchorPoint(using:)))
    }

    let isActive = gestureRecognizer.state == .began || gestureRecognizer.state == .changed
    if isActive && gestureTokens[gestureRecognizer] == nil {
      gestureTokens[gestureRecognizer] = tokenGenerator.generate()
    }
  }

  func handle(panGesture panRecognizer: UIPanGestureRecognizer) {
    var translation = panRecognizer.translation(in: target.superview)

    if panRecognizer.state == .began {
      previousTranslation = CGPoint.zero
    }

    let originalTranslation = translation
    translation.x -= previousTranslation.x
    translation.y -= previousTranslation.y
    previousTranslation = originalTranslation

    target.center.x += translation.x
    target.center.y += translation.y
  }

  func handle(rotationGesture rotationRecognizer: UIRotationGestureRecognizer) {
    if rotationRecognizer.state == .began {
      previousRotation = 0
    }

    let rotation = rotationRecognizer.rotation - previousRotation
    target.transform = target.transform.rotated(by: rotation)
    previousRotation = rotationRecognizer.rotation
  }

  func handle(pinchGesture pinchRecognizer: UIPinchGestureRecognizer) {
    if pinchRecognizer.state == .began {
      previousScale = 1
    }

    let newScale = 1 + (pinchRecognizer.scale - previousScale)
    target.transform = target.transform.scaledBy(x: newScale, y: newScale)
    previousScale = pinchRecognizer.scale
  }

  func handle(gesture: UIGestureRecognizer) {
    if gesture.state == .began && gestureTokens[gesture] == nil {
      gestureTokens[gesture] = tokenGenerator.generate()

    } else if gesture.state == .ended || gesture.state == .cancelled {
      gestureTokens[gesture]!.terminate()
      gestureTokens.removeValue(forKey: gesture)
    }
  }

  func modifyAnchorPoint(using gesture: UIGestureRecognizer) {
    if gesture.state == .began {
      emitter.emitPlan(makeAnchorPointAdjustment(using: gesture, on: target))
    }
  }

  var tokenGenerator: IsActiveTokenGenerating!
  func set(isActiveTokenGenerator: IsActiveTokenGenerating) {
    tokenGenerator = isActiveTokenGenerator
  }

  var emitter: PlanEmitting!
  func setPlanEmitter(_ planEmitter: PlanEmitting) {
    emitter = planEmitter
  }
}
