//
//  PVButtonState.m
//  PVSupport
//
//  Created by Leonardo Lobato on 26/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "PVButtonState.h"

@interface PVButtonState ()

@property (nonatomic, readwrite) float value;
@property (nonatomic, readwrite, getter = isPressed) BOOL pressed;

@end

@implementation PVButtonState

- (id)initWithValue:(float)value pressed:(BOOL)pressed;
{
    self = [super init];
    if (self) {
        self.value = value;
        self.pressed = pressed;
    }
    return self;
}

- (id)initPressed:(BOOL)pressed;
{
    self = [super init];
    if (self) {
        self.pressed = pressed;
        self.value = pressed ? 1.0f : 0.0f;
    }
    return self;
}

@end
