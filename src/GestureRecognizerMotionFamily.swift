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

public typealias GestureHandler = (_ gesture: UIGestureRecognizer) -> Void

// MARK: - General gesture
@objc public class Gesturable: NSObject, Plan {
    let gestureRecognizer: UIGestureRecognizer

    public init(withGestureRecognizer recognizer: UIGestureRecognizer) {
        self.gestureRecognizer = recognizer
        super.init()
    }

    public func performerClass() -> AnyClass {
        return GesturePerformer.self
    }
}

private class GesturePerformer: NSObject, PlanPerforming {
    fileprivate let target: UIView

    required init(target: Any) {
        self.target = target as! UIView
        super.init()
    }

    func add(plan: Plan) {
        guard let gesturable = plan as? Gesturable else { return }

        gesturable.gestureRecognizer.addTarget(self, action: #selector(handle(gesture:)))
        target.addGestureRecognizer(gesturable.gestureRecognizer)
    }

    @objc func handle(gesture: UIGestureRecognizer) {}
}

// MARK: - Block gesture
@objc public final class BlockGesturable: Gesturable {
    fileprivate let handler: GestureHandler

    public init(withGestureRecognizer recognizer: UIGestureRecognizer, handler: GestureHandler) {
        self.handler = handler
        super.init(withGestureRecognizer: recognizer)
    }

    public override func performerClass() -> AnyClass {
        return BlockGesturePerformer.self
    }
}

private final class BlockGesturePerformer: GesturePerformer {
    private var gestureHandler: GestureHandler?

    private override func add(plan: Plan) {
        guard let gesturable = plan as? BlockGesturable else { return }

        gestureHandler = gesturable.handler
        super.add(plan: plan)
    }

    private override func handle(gesture: UIGestureRecognizer) {
        gestureHandler?(gesture)
    }
}

// MARK: - Draggable gesture
@objc public final class Draggable: Gesturable {
    public init() {
        super.init(withGestureRecognizer: UIPanGestureRecognizer())
    }

    public final override func performerClass() -> AnyClass {
        return DraggablePerformer.self
    }
}

private final class DraggablePerformer: GesturePerformer {
    @objc override func handle(gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UIPanGestureRecognizer else { return }

        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: target)
            target.center.x += translation.x
            target.center.y += translation.y
            gesture.setTranslation(CGPoint.zero, in: target)
        default:
            ()
        }
    }
}
