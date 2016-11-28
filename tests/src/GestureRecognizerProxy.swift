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

import Foundation

// Testing technique adopted from: http://vojtastavik.com/2016/03/30/testing-gesture-recognizers/

// A proxy for a gesture recognizer that is able to simulate touch events.
class GestureRecognizerProxy {
  func addTarget(_ target: Any, action: Selector) {
    let targetAction = TargetAction(target: target as AnyObject, action: action)
    targetActions.append(targetAction)
  }

  func simulateTouch(location: CGPoint? = nil,
                     state: UIGestureRecognizerState,
                     with gestureRecognizer: UIGestureRecognizer) {
    self.location = location
    self.state = state

    for targetAction in targetActions {
      targetAction.target.perform(targetAction.action, with: gestureRecognizer)
    }
  }

  class TargetAction {
    let target: AnyObject
    let action: Selector

    init(target: AnyObject, action: Selector) {
      self.target = target
      self.action = action
    }
  }

  var targetActions: [TargetAction] = []

  var state: UIGestureRecognizerState?
  var location: CGPoint?
}
