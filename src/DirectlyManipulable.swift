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

  let draggable: Draggable
  let pinchable: Pinchable
  let rotatable: Rotatable

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

  /** The performer that will fulfill this plan. */
  public func performerClass() -> AnyClass {
    return DirectlyManipulablePerformer.self
  }

  /** Returns a copy of this plan. */
  public func copy(with zone: NSZone? = nil) -> Any {
    return DirectlyManipulable(draggable: draggable, pinchable: pinchable, rotatable: rotatable)
  }
}
