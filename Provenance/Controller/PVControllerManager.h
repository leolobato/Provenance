//
//  PVControllerManager.h
//  Provenance
//
//  Created by James Addyman on 19/09/2015.
//  Copyright © 2015 James Addyman. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GameController;

@class PViCadeController;

extern NSString * const PVControllerManagerControllerReassignedNotification;

@interface PVControllerManager : NSObject

+ (PVControllerManager *)sharedManager;

- (GCController *)controllerForPlayer:(NSInteger)player; // 1-Based
- (void)setController:(GCController *)controller toPlayer:(NSUInteger)player;
- (NSArray *)sortedControllers; // id<PVController>

- (NSInteger)maxControllers;

@property (nonatomic, strong) PViCadeController *iCadeController;

- (BOOL)hasControllers;

- (void)refreshiCadeControllerListener;

@end
