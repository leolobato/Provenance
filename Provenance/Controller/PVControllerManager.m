//
//  PVControllerManager.m
//  Provenance
//
//  Created by James Addyman on 19/09/2015.
//  Copyright © 2015 James Addyman. All rights reserved.
//

#import "PVControllerManager.h"
#import "PVSettingsModel.h"
#import "PViCadeController.h"
#import "kICadeControllerSetting.h"

NSString * const PVControllerManagerControllerReassignedNotification = @"PVControllerManagerControllerReassignedNotification";

@interface PVControllerManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, GCController *> *controllers; // key: Player / value: Controller

@end

@implementation PVControllerManager

+ (PVControllerManager *)sharedManager
{
    static PVControllerManager *_sharedManager;

    if (!_sharedManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedManager = [[PVControllerManager alloc] init];
        });
    }
    
    return _sharedManager;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleControllerDidConnect:)
                                                     name:GCControllerDidConnectNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleControllerDidDisconnect:)
                                                     name:GCControllerDidDisconnectNotification
                                                   object:nil];
        
        self.controllers = [[NSMutableDictionary alloc] initWithCapacity:2];

        // automatically assign the first connected controller to player 1
        // prefer gamepad or extendedGamepad over a microGamepad
        [self assignControllers];

        if (!self.iCadeController)
        {
            PVSettingsModel* settings = [PVSettingsModel sharedInstance];
            self.iCadeController = kIcadeControllerSettingToPViCadeController(settings.iCadeControllerSetting);
            if (self.iCadeController) {
                [self listenForICadeControllers];
            }
        }
    }

    return self;
}

- (NSArray *)sortedControllers;
{
    NSMutableArray *controllers = [[NSMutableArray alloc] initWithCapacity:self.controllers.count];
    
    NSArray *players = [[self.controllers allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (NSString *player in players) {
        [controllers addObject:[self.controllers objectForKey:player]];
    }
    return controllers;
}

- (NSInteger)maxControllers;
{
    return 4;
}

- (BOOL)hasControllers
{
    return self.controllers.count>0;
}

- (void)refreshiCadeControllerListener;
{
    [self.iCadeController refreshListener];
}

- (void)handleControllerDidConnect:(NSNotification *)note
{
    GCController *controller = [note object];
    NSLog(@"Controller connected: %@", [controller vendorName]);

    [self assignController:controller];
}

- (void)handleControllerDidDisconnect:(NSNotification *)note
{
    GCController *controller = [note object];
    NSLog(@"Controller disconnected: %@", [controller vendorName]);

    for (NSString *player in self.controllers.allKeys) {
        if ([self.controllers objectForKey:player]==controller) {
            [self.controllers removeObjectForKey:player];
            break;
        }
    }
    
    // Reassign any controller which we are unassigned
    BOOL assigned = [self assignControllers];
    if (!assigned) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PVControllerManagerControllerReassignedNotification
                                                            object:self];
    }
}

- (void)listenForICadeControllers
{
    __weak PVControllerManager* weakSelf = self;
    self.iCadeController.controllerPressedAnyKey = ^(PViCadeController* controller) {
        weakSelf.iCadeController.controllerPressedAnyKey = nil;
        [weakSelf assignController:weakSelf.iCadeController];
    };
}

#pragma mark - Controllers assignment

- (void)setController:(GCController *)controller toPlayer:(NSUInteger)player;
{
#if TARGET_OS_TV
    if ([controller microGamepad])
    {
        [[controller microGamepad] setAllowsRotation:YES];
        [[controller microGamepad] setReportsAbsoluteDpadValues:YES];
    }
#endif
    
    controller.playerIndex = (player-1);
    
    NSString *key = [[NSNumber numberWithUnsignedInteger:player] stringValue];
    if (controller) {
        [self.controllers setObject:controller forKey:key];
    } else {
        [self.controllers removeObjectForKey:key];
    }
    
    if (controller) {
        NSLog(@"Controller [%@] assigned to player %@", [controller vendorName], [NSNumber numberWithUnsignedInteger:player]);
    }
}

- (GCController *)controllerForPlayer:(NSInteger)player;
{
    return [self.controllers objectForKey:[[NSNumber numberWithUnsignedInteger:player] stringValue]];
}

- (BOOL)assignControllers;
{
    NSMutableArray *controllers = [[GCController controllers] mutableCopy];
    if (self.iCadeController) {
        [controllers addObject:self.iCadeController];
    }
    
    BOOL assigned = NO;
    NSArray *alreadyAssigned = [self sortedControllers];
    for (GCController *controller in controllers) {
        if (![alreadyAssigned containsObject:controller]) {
            assigned = assigned || [self assignController:controller];
        }
    }
    return assigned;
}

- (BOOL)assignController:(GCController *)controller;
{
    // Assign the controller to the first player without a controller assigned, or
    // if this is an extended controller, replace the first controller which is not extended (the Siri remote on tvOS).
    for (NSUInteger i = 1; i<=[self maxControllers]; i++) {
        GCController *previouslyAssignedController = [self controllerForPlayer:i];
        if (!previouslyAssignedController || (controller.extendedGamepad && !previouslyAssignedController.extendedGamepad)) {
            [self setController:controller toPlayer:i];
            
            // Move the previously assigned controller to another player
            if (previouslyAssignedController) {
                [self assignController:previouslyAssignedController];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:PVControllerManagerControllerReassignedNotification
                                                                object:self];
            
            return YES;
        }
    }
    
    return NO;
}


@end
