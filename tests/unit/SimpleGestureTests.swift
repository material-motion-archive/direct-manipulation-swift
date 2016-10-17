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
@testable import MaterialMotionDirectManipulationFamily

class SimpleGestureTests: XCTestCase {

  func testThatPlanAttachesRecognizerToTargetView() {
    let view = UIView()

    let scheduler = Scheduler()

    let draggable = Draggable()

    scheduler.addPlan(draggable, to: view)

    XCTAssert(view.gestureRecognizers?.contains(draggable.panGestureRecognizer) ?? false, "View should have pan gesture recognizer attached")
  }

  func testThatMultiplePlansAttachRecognizersToTargetView() {
    let view = UIView()

    let plans: [Plan] = [
      Draggable(),
      Pinchable(),
      Rotatable()
    ]

    let scheduler = Scheduler()

    for plan in plans {
      scheduler.addPlan(plan, to: view)
    }

    XCTAssert(view.gestureRecognizers?.count ?? 0 == plans.count, "View should have 3 gesture recognizers attached")
  }

  func testThatTargetActionIsAddedToRecognizerUnderDraggablePlan() {
    let targetView = UIView()

    let recognizer = TestablePanGestureRecognizer()
    let plan = Draggable(withGestureRecognizer: recognizer)

    let scheduler = Scheduler()

    scheduler.addPlan(plan, to: targetView)

    guard recognizer.target is DraggablePerformer else {
      XCTFail("Pan gesture recognizer should have a DraggablePerformer target")
      return
    }

    let selector = #selector(DraggablePerformer.handle(gesture:))
    guard let action = recognizer.action, action == selector else {
      XCTFail("Pan gesture recognizer should have an action matching 'handle(gesture:)'")
      return
    }
  }
}
