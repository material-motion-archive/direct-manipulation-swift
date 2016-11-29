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

final class AnchorPointPerformer: NSObject, Performing {
  let target: UIView

  init(target: Any) {
    self.target = target as! UIView
    super.init()
  }

  func addPlan(_ plan: Plan) {
    switch plan {
    case let plan as ChangeAnchorPoint:
      changeAnchorPointForView(target, anchorPoint: plan.anchorPoint)
    case let plan as AdjustsAnchorPoint:
      plan.gestureRecognizer.addTarget(self, action: #selector(modifyAnchorPoint(using:)))
    default:
      assertionFailure("Unhandled plan type: \(plan)")
    }
  }

  func modifyAnchorPoint(using gesture: UIGestureRecognizer) {
    if gesture.state == .began {
      let locationInView = gesture.location(in: target)
      let anchorPoint = CGPoint(x: locationInView.x / target.bounds.width,
                                y: locationInView.y / target.bounds.height)
      changeAnchorPointForView(target, anchorPoint: anchorPoint)
    }
  }
}
