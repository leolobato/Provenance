//
//  PVRemoteControllerViewController.h
//  Provenance
//
//  Created by Leonardo Lobato on 19/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "PVControllerLayoutViewController.h"

@import VirtualGameController;
@import GameController;

@interface PVRemoteControllerViewController : PVControllerLayoutViewController

@property (nonatomic, strong) Peripheral *peripheral;

@end
