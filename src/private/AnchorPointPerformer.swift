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

/**
 Creates and returns a Transaction consisting of a ChangeAnchorPoint plan.

 - Parameter gestureRecognizer: Recognizer used to determine touch location
 - Parameter target: The view that will have its anchor point changed

 - Returns: A Transaction consisting of a ChangeAnchorPoint plan
 */
func makeAnchorPointAdjustment(using gestureRecognizer: UIGestureRecognizer, on target: UIView) -> ChangeAnchorPoint {
  // Determine the new anchor point
  let locationInView = gestureRecognizer.location(in: target)
  let anchorPoint = CGPoint(x: locationInView.x / target.bounds.width, y: locationInView.y / target.bounds.height)

  return ChangeAnchorPoint(withAnchorPoint: anchorPoint)
}
