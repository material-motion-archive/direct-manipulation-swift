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
@testable import MaterialMotionDirectManipulationFamily

class GestureTests: XCTestCase {

  func testThatGestureAttachesToTargetView() {
    let view = UIView()

    let draggable = Draggable()

    let transaction = Transaction()
    transaction.add(plan: draggable, to: view)

    let scheduler = Scheduler()
    scheduler.commit(transaction: transaction)

    XCTAssert(view.gestureRecognizers?.contains(draggable.panGestureRecognizer) ?? false, "View should have pan gesture attached")
  }

  func testThatMultipleGesturesAttachToTargetView() {
    let view = UIView()

    let gestures = [
      Draggable(),
      Draggable(),
      Draggable()
    ]

    let transaction = Transaction()

    for gesture in gestures {
      transaction.add(plan: gesture, to: view)
    }

    let scheduler = Scheduler()
    scheduler.commit(transaction: transaction)

    XCTAssert(view.gestureRecognizers?.count ?? 0 == gestures.count, "View should have 3 gestures attached")
  }
}
