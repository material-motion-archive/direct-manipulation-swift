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
 Modifies the anchor point of a target while maintaining the view/layer's current
 visible frame.

 Supported target types: UIView, CALayer.
 */
@objc(MDMChangeAnchorPoint)
@available(*, deprecated, message: "Add AdjustsAnchorPoint instead. Deprecated in #develop#.")
public final class ChangeAnchorPoint: NSObject, Plan {

  /**
   The new anchor point, expressed in the [0,1] range for each x and y value.

   0 corresponds to the min value of the bounds' corresponding axis.
   1 corresponds to the max value of the bounds' corresponding axis.
   */
  let anchorPoint: CGPoint

  /**
   Initialize the plan object with an anchor point.

   See the anchorPoint documentation for an explanation of the expected value range.
   */
  public init(withAnchorPoint anchorPoint: CGPoint) {
    self.anchorPoint = anchorPoint
    super.init()
  }

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return AnchorPointPerformer.self
  }

  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    return ChangeAnchorPoint(withAnchorPoint: anchorPoint)
  }
}

/**
 Changes the anchor point of a given view to the provided anchorPoint while maintaining the view's
 frame.

 @param anchorPoint The new anchor point, expressed in the [0,1] range for each x and y value.
 0 corresponds to the min value of the bounds' corresponding axis.
 1 corresponds to the max value of the bounds' corresponding axis.
 */
public func changeAnchorPointForView(_ view: UIView, anchorPoint: CGPoint) {
  let newPosition = CGPoint(x: anchorPoint.x * view.layer.bounds.width,
                            y: anchorPoint.y * view.layer.bounds.height)

  let positionInSuperview = view.convert(newPosition, to: view.superview)

  view.layer.anchorPoint = anchorPoint
  view.layer.position = positionInSuperview
}
