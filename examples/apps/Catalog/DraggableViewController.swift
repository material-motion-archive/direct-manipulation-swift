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
import MaterialMotionGesturesFamily
import MaterialMotionRuntime

class DraggableViewController: UIViewController {

    let scheduler = Scheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        let draggableView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        draggableView.center = CGPoint(x: view.frame.midX, y: view.frame.midY)
        draggableView.backgroundColor = UIColor.red
        view.addSubview(draggableView)

        let transaction = Transaction()

        let gesturable = BlockGesturable(withGestureRecognizer: UITapGestureRecognizer()) { gesture in
            let location = gesture.location(in: gesture.view!)
            print("tapped \(location.x), \(location.y)")
        }

        transaction.add(plan: Draggable(), to: draggableView)
        transaction.add(plan: gesturable, to: draggableView)

        scheduler.commit(transaction: transaction)
    }
}
