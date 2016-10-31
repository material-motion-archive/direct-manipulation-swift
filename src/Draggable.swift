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

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return DraggablePerformer.self
  }

  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    let draggable = Draggable(withGestureRecognizer: panGestureRecognizer)
    draggable.shouldAdjustAnchorPointOnGestureStart = shouldAdjustAnchorPointOnGestureStart
    return draggable
  }
}
