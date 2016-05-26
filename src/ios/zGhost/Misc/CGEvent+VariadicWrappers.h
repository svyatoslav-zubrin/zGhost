//
//  CGEvent+VariadicWrappers.h
//  zGhost
//
//  Created by Slava Zubrin on 5/25/16.
//  Copyright © 2016 Slava Zubrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

CF_IMPLICIT_BRIDGING_ENABLED
CGEventRef __nullable CreateScrollWheelEvent(CGEventSourceRef __nullable source, CGScrollEventUnit units, int32_t wheel);
CF_IMPLICIT_BRIDGING_DISABLED