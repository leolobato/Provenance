//
//  PVController.h
//  PVSupport
//
//  Created by Leonardo Lobato on 26/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PVControllerState.h"

@protocol PVController <NSObject>

- (NSInteger)playerNumber; // 0-Based
- (PVControllerState *)controllerState;

- (BOOL)supportsStartSelect;

@end
