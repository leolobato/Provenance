//
//  PVControllerViewController.m
//  Provenance
//
//  Created by James Addyman on 03/09/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "PVControllerViewController.h"
#import "PVSettingsModel.h"
#import "PVControllerManager.h"

@interface PVControllerViewController ()

@end

@implementation PVControllerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(controllerDidConnect:)
												 name:GCControllerDidConnectNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(controllerDidDisconnect:)
												 name:GCControllerDidDisconnectNotification
											   object:nil];

    [self refreshControllerVisibility];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self refreshControllerVisibility];
}


#pragma mark - GameController Notifications

- (void)controllerDidConnect:(NSNotification *)note
{
    [self refreshControllerVisibility];
}

- (void)controllerDidDisconnect:(NSNotification *)note
{
    [self refreshControllerVisibility];
}

- (void)refreshControllerVisibility;
{
    if ([[PVControllerManager sharedManager] hasControllers]) {
        [self hideTouchControls:YES forController:[[PVControllerManager sharedManager] player1]];
        [self hideTouchControls:YES forController:[[PVControllerManager sharedManager] player2]];
    } else {
        [self hideTouchControls:NO forController:nil];
    }
}

#pragma mark - PVControllerLayoutViewController

- (CGFloat)controllerOpacity;
{
    return [[PVSettingsModel sharedInstance] controllerOpacity];
}

- (BOOL)vibrationEnabled;
{
    return [[PVSettingsModel sharedInstance] buttonVibration];
}


@end
