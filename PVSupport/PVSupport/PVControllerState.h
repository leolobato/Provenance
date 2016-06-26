//
//  PVControllerState.h
//  PVSupport
//
//  Created by Leonardo Lobato on 26/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PVButtonState.h"
#import "PVControllerAxisDirection.h"

@interface PVControllerState : NSObject

@property (nonatomic, assign) PVControllerAxisDirection dPadDirection;

@property (nonatomic, strong) PVButtonState *buttonA;
@property (nonatomic, strong) PVButtonState *buttonB;
@property (nonatomic, strong) PVButtonState *buttonX;
@property (nonatomic, strong) PVButtonState *buttonY;
@property (nonatomic, strong) PVButtonState *leftShoulder;
@property (nonatomic, strong) PVButtonState *rightShoulder;
@property (nonatomic, strong) PVButtonState *leftTrigger;
@property (nonatomic, strong) PVButtonState *rightTrigger;

@end
