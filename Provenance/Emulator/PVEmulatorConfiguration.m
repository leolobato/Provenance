//
//  PVEmulatorConfiguration.m
//  Provenance
//
//  Created by James Addyman on 02/09/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "PVEmulatorConfiguration.h"
#import "PVEmulatorConstants.h"

#import "PVGenesisEmulatorCore.h"
#import "PVGenesisControllerViewController.h"

#import "PVSNESEmulatorCore.h"
#import "PVSNESControllerViewController.h"

#import "PVGBAEmulatorCore.h"
#import "PVGBAControllerViewController.h"

#import "PVGBEmulatorCore.h"
#import "PVGBControllerViewController.h"

#import "PVNESEmulatorCore.h"
#import "PVNESControllerViewController.h"

@interface PVEmulatorConfiguration ()

@end

@implementation PVEmulatorConfiguration

- (PVEmulatorCore *)emulatorCoreForSystemIdentifier:(NSString *)systemID
{
	PVEmulatorCore *core = nil;
	
	if ([systemID isEqualToString:PVGenesisSystemIdentifier] ||
        [systemID isEqualToString:PVGameGearSystemIdentifier] ||
        [systemID isEqualToString:PVMasterSystemSystemIdentifier] ||
        [systemID isEqualToString:PVSegaCDSystemIdentifier] ||
        [systemID isEqualToString:PVSG1000SystemIdentifier])
	{
		core = [[PVGenesisEmulatorCore alloc] init];
	}
	else if ([systemID isEqualToString:PVSNESSystemIdentifier])
	{
		core = [[PVSNESEmulatorCore alloc] init];
	}
    else if ([systemID isEqualToString:PVGBASystemIdentifier])
    {
        core = [[PVGBAEmulatorCore alloc] init];
    }
    else if ([systemID isEqualToString:PVGBSystemIdentifier] ||
             [systemID isEqualToString:PVGBCSystemIdentifier])
    {
        core = [[PVGBEmulatorCore alloc] init];
    }
    else if ([systemID isEqualToString:PVNESSystemIdentifier] ||
             [systemID isEqualToString:PVFDSSystemIdentifier])
    {
        core = [[PVNESEmulatorCore alloc] init];
    }
	
	return core;
}

- (PVControllerViewController *)controllerViewControllerForSystemIdentifier:(NSString *)systemID
{
	PVControllerViewController *controller = nil;
	
    if ([systemID isEqualToString:PVGenesisSystemIdentifier] ||
        [systemID isEqualToString:PVGameGearSystemIdentifier] ||
        [systemID isEqualToString:PVMasterSystemSystemIdentifier] ||
        [systemID isEqualToString:PVSegaCDSystemIdentifier] ||
        [systemID isEqualToString:PVSG1000SystemIdentifier])
	{
		controller = [[PVGenesisControllerViewController alloc] initWithControlLayout:[self controllerLayoutForSystem:systemID] systemIdentifier:systemID];
	}
	else if ([systemID isEqualToString:PVSNESSystemIdentifier])
	{
		controller = [[PVSNESControllerViewController alloc] initWithControlLayout:[self controllerLayoutForSystem:systemID] systemIdentifier:systemID];
	}
    else if ([systemID isEqualToString:PVGBASystemIdentifier])
    {
        controller = [[PVGBAControllerViewController alloc] initWithControlLayout:[self controllerLayoutForSystem:systemID] systemIdentifier:systemID];
    }
    else if ([systemID isEqualToString:PVGBSystemIdentifier] ||
             [systemID isEqualToString:PVGBCSystemIdentifier])
    {
        controller = [[PVGBControllerViewController alloc] initWithControlLayout:[self controllerLayoutForSystem:systemID] systemIdentifier:systemID];
    }
    else if ([systemID isEqualToString:PVNESSystemIdentifier] ||
             [systemID isEqualToString:PVFDSSystemIdentifier])
    {
        controller = [[PVNESControllerViewController alloc] initWithControlLayout:[self controllerLayoutForSystem:systemID] systemIdentifier:systemID];
    }
	
	return controller;
}

@end
