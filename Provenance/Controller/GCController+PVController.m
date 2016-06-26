//
//  GCController+PVController.m
//  Provenance
//
//  Created by Leonardo Lobato on 26/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "GCController+PVController.h"

#import "PVControllerState.h"
#import "PVGameControllerUtilities.h"

@implementation GCController (PVController)

- (NSInteger)playerNumber;
{
    return self.playerIndex;
}

- (BOOL)supportsStartSelect;
{
    return [self extendedGamepad]!=nil;        
}

- (PVControllerState *)controllerState;
{
    PVControllerState *state = [[PVControllerState alloc] init];
    
    if ([self extendedGamepad])
    {
        GCExtendedGamepad *pad = [self extendedGamepad];
        GCControllerDirectionPad *dpad = [pad dpad];
        
        PVControllerAxisDirection axisDirection = [PVGameControllerUtilities axisDirectionForThumbstick:pad.leftThumbstick];
        
        BOOL upPressed = dpad.up.pressed || axisDirection == PVControllerAxisDirectionUp || axisDirection == PVControllerAxisDirectionUpLeft || axisDirection == PVControllerAxisDirectionUpRight;
        BOOL downPressed = dpad.down.pressed || axisDirection == PVControllerAxisDirectionDown || axisDirection == PVControllerAxisDirectionDownLeft || axisDirection == PVControllerAxisDirectionDownRight;
        BOOL leftPressed = dpad.left.pressed || axisDirection == PVControllerAxisDirectionLeft || axisDirection == PVControllerAxisDirectionUpLeft || axisDirection == PVControllerAxisDirectionDownLeft;
        BOOL rightPressed = dpad.right.pressed || axisDirection == PVControllerAxisDirectionRight || axisDirection == PVControllerAxisDirectionUpRight || axisDirection == PVControllerAxisDirectionDownRight;
        
        state.dPadDirection = [self axisForUp:upPressed down:downPressed left:leftPressed right:rightPressed];
        
        state.buttonA = [[PVButtonState alloc] initPressed:pad.buttonA.isPressed];
        state.buttonB = [[PVButtonState alloc] initPressed:pad.buttonB.isPressed];
        state.buttonX = [[PVButtonState alloc] initPressed:pad.buttonX.isPressed];
        state.buttonY = [[PVButtonState alloc] initPressed:pad.buttonY.isPressed];
        
        state.leftShoulder = [[PVButtonState alloc] initPressed:pad.leftShoulder.isPressed];
        state.rightShoulder = [[PVButtonState alloc] initPressed:pad.rightShoulder.isPressed];
        state.leftTrigger = [[PVButtonState alloc] initWithValue:pad.leftTrigger.value pressed:pad.leftTrigger.isPressed];
        state.rightTrigger = [[PVButtonState alloc] initWithValue:pad.rightTrigger.value pressed:pad.rightTrigger.isPressed];
        
    }
    else if ([self gamepad])
    {
        GCGamepad *pad = [self gamepad];
        GCControllerDirectionPad *dpad = [pad dpad];

        BOOL upPressed = dpad.up.pressed;
        BOOL downPressed = dpad.down.pressed;
        BOOL leftPressed = dpad.left.pressed;
        BOOL rightPressed = dpad.right.pressed;
        
        state.dPadDirection = [self axisForUp:upPressed down:downPressed left:leftPressed right:rightPressed];

        state.buttonA = [[PVButtonState alloc] initPressed:pad.buttonA.isPressed];
        state.buttonB = [[PVButtonState alloc] initPressed:pad.buttonB.isPressed];
        state.buttonX = [[PVButtonState alloc] initPressed:pad.buttonX.isPressed];
        state.buttonY = [[PVButtonState alloc] initPressed:pad.buttonY.isPressed];
        
        state.leftShoulder = [[PVButtonState alloc] initPressed:pad.leftShoulder.isPressed];
        state.rightShoulder = [[PVButtonState alloc] initPressed:pad.rightShoulder.isPressed];
    }
#if TARGET_OS_TV
    else if ([self microGamepad])
    {
        GCMicroGamepad *pad = [self microGamepad];
        GCControllerDirectionPad *dpad = [pad dpad];

        BOOL upPressed = dpad.up.value > 0.5;
        BOOL downPressed = dpad.down.value > 0.5;
        BOOL leftPressed = dpad.left.value > 0.5;
        BOOL rightPressed = dpad.right.value > 0.5;

        state.dPadDirection = [self axisForUp:upPressed down:downPressed left:leftPressed right:rightPressed];
        
        state.buttonA = [[PVButtonState alloc] initPressed:pad.buttonA.isPressed];
        state.buttonX = [[PVButtonState alloc] initPressed:pad.buttonX.isPressed];
    }
#endif
    
    return state;

}

- (PVControllerAxisDirection)axisForUp:(BOOL)upPressed down:(BOOL)downPressed left:(BOOL)leftPressed right:(BOOL)rightPressed;
{
    if (upPressed && leftPressed) {
        return PVControllerAxisDirectionUpLeft;
    } else if (upPressed && rightPressed) {
        return PVControllerAxisDirectionUpRight;
    } else if (upPressed) {
        return PVControllerAxisDirectionUp;
    } else if (downPressed && leftPressed) {
        return PVControllerAxisDirectionDownLeft;
    } else if (downPressed && rightPressed) {
        return PVControllerAxisDirectionDownRight;
    } else if (downPressed) {
        return PVControllerAxisDirectionDown;
    } else if (leftPressed) {
        return PVControllerAxisDirectionLeft;
    } else if (rightPressed) {
        return PVControllerAxisDirectionRight;
    } else {
        return PVControllerAxisDirectionNone;
    }

}

@end
