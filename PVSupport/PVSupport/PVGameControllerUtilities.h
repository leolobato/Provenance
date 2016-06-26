//
//  PVGameControllerUtilities.h
//  PVSupport
//
//  Created by Tyler Hedrick on 4/3/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

@class GCControllerDirectionPad;

#import "PVControllerAxisDirection.h"

@interface PVGameControllerUtilities : NSObject
+ (PVControllerAxisDirection)axisDirectionForThumbstick:(GCControllerDirectionPad *)thumbstick;
@end
