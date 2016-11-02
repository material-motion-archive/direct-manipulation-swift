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

final class DirectlyManipulablePerformer: NSObject, ComposablePerforming {
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
      plan.panGestureRecognizer,
      plan.pinchGestureRecognizer,
      plan.rotationGestureRecognizer
    ]

    for recognizer in gestureRecognizers {
      // Set ourselves as each recognizer's delegate, if possible,
      // in order to allow simultaneous recognition
      if recognizer.delegate == nil {
        recognizer.delegate = self
      }
    }

    emitter.emitPlan(Draggable(withGestureRecognizer: plan.panGestureRecognizer))
    emitter.emitPlan(Pinchable(withGestureRecognizer: plan.pinchGestureRecognizer))
    emitter.emitPlan(Rotatable(withGestureRecognizer: plan.rotationGestureRecognizer))
  }

  var emitter: PlanEmitting!
  func setPlanEmitter(_ planEmitter: PlanEmitting) {
    emitter = planEmitter
  }
}

extension DirectlyManipulablePerformer: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    /// Allow the performer's gesture recognizers to recognizer simultaneously
    return gestureRecognizers.contains(otherGestureRecognizer)
  }
}
