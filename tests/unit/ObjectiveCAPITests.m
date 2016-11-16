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

#import <XCTest/XCTest.h>
@import MaterialMotionRuntime;
@import MaterialMotionDirectManipulation;

@interface ObjectiveCAPITests : XCTestCase
@end

@implementation ObjectiveCAPITests

- (void)testThatDraggablePlansCanBeCreated {
  MDMDraggable *draggable = [[MDMDraggable alloc] init];
  MDMDraggable *dragWithGesture = [[MDMDraggable alloc] initWithGestureRecognizer:[[UIPanGestureRecognizer alloc] init]];

  draggable.shouldAdjustAnchorPointOnGestureStart = YES;
  dragWithGesture.shouldAdjustAnchorPointOnGestureStart = YES;
}

- (void)testThatPinchablePlansCanBeCreated {
  MDMPinchable *pinchable = [[MDMPinchable alloc] init];
  MDMPinchable *pinchWithGesture = [[MDMPinchable alloc] initWithGestureRecognizer:[[UIPinchGestureRecognizer alloc] init]];

  pinchable.shouldAdjustAnchorPointOnGestureStart = YES;
  pinchWithGesture.shouldAdjustAnchorPointOnGestureStart = YES;
}

- (void)testThatRotatablePlansCanBeCreated {
  MDMRotatable *rotatable = [[MDMRotatable alloc] init];
  MDMRotatable *rotateWithGesture = [[MDMRotatable alloc] initWithGestureRecognizer:[[UIRotationGestureRecognizer alloc] init]];

  rotatable.shouldAdjustAnchorPointOnGestureStart = YES;
  rotateWithGesture.shouldAdjustAnchorPointOnGestureStart = YES;
}

- (void)testThatDirectlyManipulablePlansCanBeCreated {
  __unused MDMDirectlyManipulable *directlyManipulable = [[MDMDirectlyManipulable alloc] init];
  __unused MDMDirectlyManipulable *directlyManipulableWithGesture =
      [[MDMDirectlyManipulable alloc] initWithPanGestureRecognizer:[UIPanGestureRecognizer new]
                                            pinchGestureRecognizer:[UIPinchGestureRecognizer new]
                                         rotationGestureRecognizer:[UIRotationGestureRecognizer new]];
}

- (void)testThatChangeAnchorPointPlansCanBeCreated {
  __unused MDMChangeAnchorPoint *changeAnchorPoint = [[MDMChangeAnchorPoint alloc] initWithAnchorPoint:CGPointMake(0.5, 0.5)];
}

@end
