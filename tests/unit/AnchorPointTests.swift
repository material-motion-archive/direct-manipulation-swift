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

import XCTest
import MaterialMotionRuntime
import MaterialMotionDirectManipulationFamily

class AnchorPointTests: XCTestCase {
  func testThatAnchorPointIsModifiedByDraggablePerformer() {
    let pan = TestablePanGestureRecognizer()
    let draggable = Draggable(withGestureRecognizer: pan)
    draggable.shouldAdjustAnchorPointOnGestureStart = true
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    let scheduler = Scheduler()
    scheduler.addPlan(draggable, to: view)

    pan.performTouch(location: CGPoint(x: 10, y: 20), state: .began)

    XCTAssertEqual(view.layer.anchorPoint, CGPoint(x: 0.1, y: 0.2))
  }

  func testThatAnchorPointIsModifiedByPinchablePerformer() {
    let pinch = TestablePinchGestureRecognizer()
    let pinchable = Pinchable(withGestureRecognizer: pinch)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    let scheduler = Scheduler()
    scheduler.addPlan(pinchable, to: view)

    pinch.performTouch(location: CGPoint(x: 10, y: 20), state: .began)

    XCTAssertEqual(view.layer.anchorPoint, CGPoint(x: 0.1, y: 0.2))
  }

  func testThatAnchorPointIsModifiedByRotatablePerformer() {
    let rotate = TestableRotationGestureRecognizer()
    let rotatable = Rotatable(withGestureRecognizer: rotate)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    let scheduler = Scheduler()
    scheduler.addPlan(rotatable, to: view)

    rotate.performTouch(location: CGPoint(x: 10, y: 20), state: .began)

    XCTAssertEqual(view.layer.anchorPoint, CGPoint(x: 0.1, y: 0.2))
  }

  func testThatPinchableAnchorPointFlagPreventsModification() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

    let pinch = TestablePinchGestureRecognizer()
    let pinchable = Pinchable(withGestureRecognizer: pinch)
    pinchable.shouldAdjustAnchorPointOnGestureStart = false

    let scheduler = Scheduler()
    scheduler.addPlan(pinchable, to: view)

    pinch.performTouch(location: CGPoint(x: 10, y: 20), state: .began)

    XCTAssertEqual(view.layer.anchorPoint, CGPoint(x: 0.5, y: 0.5))
  }
}
