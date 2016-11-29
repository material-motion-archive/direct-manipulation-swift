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
import MaterialMotionDirectManipulation

class GestureActionTests: XCTestCase {
  func testThatDraggableDrags() {
    let pan = TestablePanGestureRecognizer()
    let draggable = Draggable(withGestureRecognizer: pan)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    let runtime = MotionRuntime()
    runtime.addPlan(draggable, to: view)

    pan.performTouch(state: .began)
    pan.performTouch(translation: CGPoint(x: 25, y: -50), state: .changed)

    let newCenter = CGPoint(x: 25+25, y: 25-50)
    XCTAssertEqual(newCenter, view.center, "View's center (\(view.center.x), \(view.center.y)) should be (\(newCenter.x), \(newCenter.y))")
  }

  func testThatPinchableScales() {
    let pinch = TestablePinchGestureRecognizer()
    let pinchable = Pinchable(withGestureRecognizer: pinch)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))

    let runtime = MotionRuntime()
    runtime.addPlan(pinchable, to: view)

    pinch.performTouch(scale: 1, state: .began)
    pinch.performTouch(scale: 0.50, state: .changed)

    XCTAssertEqual(view.frame.width, 50, "View's width (\(view.bounds.width)) should equal 50")
    XCTAssertEqual(view.frame.height, 40, "View's height (\(view.bounds.height)) should equal 40")
  }

  func testThatRotatableRotates() {
    let rotateGesture = TestableRotationGestureRecognizer()
    let rotatable = Rotatable(withGestureRecognizer: rotateGesture)
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 80))

    let runtime = MotionRuntime()
    runtime.addPlan(rotatable, to: view)

    rotateGesture.performTouch(state: .began)
    rotateGesture.performTouch(rotation: CGFloat.pi / 2, state: .changed)

    let rotation = atan2(view.transform.b, view.transform.a)

    XCTAssertEqual(rotation, CGFloat.pi / 2, "View's rotation (\(rotation) should equal Pi / 2")
  }

  @available(*, deprecated)
  func testThatAnchorPointIsModified() {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    let newAnchorPoint = CGPoint(x: 0.33, y: 0.33)
    let changeAnchor = ChangeAnchorPoint(withAnchorPoint: newAnchorPoint)

    let runtime = MotionRuntime()
    runtime.addPlan(changeAnchor, to: view)

    XCTAssertEqual(view.layer.anchorPoint, newAnchorPoint,
                   "View's anchor point (\(view.layer.anchorPoint.x), \(view.layer.anchorPoint.y)) should be (\(newAnchorPoint.x), \(newAnchorPoint.y))")
  }
}
