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

import UIKit.UIGestureRecognizerSubclass
import XCTest
import MaterialMotionRuntime
@testable import MaterialMotionDirectManipulation

class SimpleGestureTests: XCTestCase {

  func testThatPlanAttachesRecognizerToTargetView() {
    let view = UIView()

    let runtime = MotionRuntime()

    let draggable = Draggable()

    runtime.addPlan(draggable, to: view)

    XCTAssert(view.gestureRecognizers?.contains(draggable.panGestureRecognizer) ?? false, "View should have pan gesture recognizer attached")
  }

  func testThatUserInteractionIsEnabled() {
    let view = UIView()
    view.isUserInteractionEnabled = false

    let runtime = MotionRuntime()

    runtime.addPlan(Draggable(), to: view)

    XCTAssertTrue(view.isUserInteractionEnabled)
  }

  func testThatMultiplePlansAttachRecognizersToTargetView() {
    let view = UIView()

    let plans: [Plan] = [
      Draggable(),
      Pinchable(),
      Rotatable()
    ]

    let runtime = MotionRuntime()

    for plan in plans {
      runtime.addPlan(plan, to: view)
    }

    XCTAssert(view.gestureRecognizers?.count ?? 0 == plans.count, "View should have 3 gesture recognizers attached")
  }

  func testThatTargetActionIsAddedToRecognizerUnderDraggablePlan() {
    let targetView = UIView()

    let recognizer = TestablePanGestureRecognizer()
    let plan = Draggable(withGestureRecognizer: recognizer)

    let runtime = MotionRuntime()
    runtime.addPlan(plan, to: targetView)

    guard recognizer.targets.first is GesturePerformer else {
      XCTFail("Pan gesture recognizer should have a DraggablePerformer target")
      return
    }

    let selector = #selector(GesturePerformer.handle(gesture:))
    guard recognizer.actions.contains(selector) else {
      XCTFail("Pan gesture recognizer should have an action matching 'handle(gesture:)'")
      return
    }
  }

  func testThatTargetActionIsAddedToRecognizerUnderPinchablePlan() {
    let targetView = UIView()

    let recognizer = TestablePinchGestureRecognizer()
    let plan = Pinchable(withGestureRecognizer: recognizer)

    let runtime = MotionRuntime()
    runtime.addPlan(plan, to: targetView)

    guard recognizer.targets.first is GesturePerformer else {
      XCTFail("Pinch gesture recognizer should have a PinchablePerformer target")
      return
    }

    let selector = #selector(GesturePerformer.handle(gesture:))
    guard recognizer.actions.contains(selector) else {
      XCTFail("Pinch gesture recognizer should have an action matching 'handle(gesture:)'")
      return
    }
  }

  func testThatTargetActionIsAddedToRecognizerUnderRotatablePlan() {
    let targetView = UIView()

    let recognizer = TestableRotationGestureRecognizer()
    let plan = Rotatable(withGestureRecognizer: recognizer)

    let runtime = MotionRuntime()
    runtime.addPlan(plan, to: targetView)

    guard recognizer.targets.first is GesturePerformer else {
      XCTFail("Rotation gesture recognizer should have a RotatablePerformer target")
      return
    }

    let selector = #selector(GesturePerformer.handle(gesture:))
    guard recognizer.actions.contains(selector) else {
      XCTFail("Rotation gesture recognizer should have an action matching 'handle(gesture:)'")
      return
    }
  }
}
