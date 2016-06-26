//
//  PVButtonState.h
//  PVSupport
//
//  Created by Leonardo Lobato on 26/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVButtonState : NSObject

@property (nonatomic, readonly) float value;
@property (nonatomic, readonly, getter = isPressed) BOOL pressed;

- (id)initWithValue:(float)value pressed:(BOOL)pressed;
- (id)initPressed:(BOOL)pressed;

@end
