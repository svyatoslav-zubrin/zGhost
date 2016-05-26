//
//  CGEvent+VariadicWrappers.m
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

#import "CGEvent+VariadicWrappers.h"

CGEventRef __nullable CreateScrollWheelEvent(CGEventSourceRef __nullable source, CGScrollEventUnit units, int32_t wheel) {
    return CGEventCreateScrollWheelEvent(source, units, 1, wheel);
}