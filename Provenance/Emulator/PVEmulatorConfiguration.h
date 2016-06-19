//
//  PVEmulatorConfiguration.h
//  Provenance
//
//  Created by James Addyman on 02/09/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "PVEmulatorSystemsConfiguration.h"

@class PVEmulatorCore, PVControllerViewController;

@interface PVEmulatorConfiguration : PVEmulatorSystemsConfiguration

- (PVEmulatorCore *)emulatorCoreForSystemIdentifier:(NSString *)systemID;
- (PVControllerViewController *)controllerViewControllerForSystemIdentifier:(NSString *)systemID;

@end
