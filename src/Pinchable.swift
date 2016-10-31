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

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return PinchablePerformer.self
  }

  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    let pinchable = Pinchable(withGestureRecognizer: pinchGestureRecognizer)
    pinchable.shouldAdjustAnchorPointOnGestureStart = shouldAdjustAnchorPointOnGestureStart
    return pinchable
  }
}
