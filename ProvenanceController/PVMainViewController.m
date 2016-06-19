//
//  PVMainViewController.m
//  ProvenanceController
//
//  Created by Leonardo Lobato on 19/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "PVMainViewController.h"

#import "PVEmulatorConstants.h"
#import "PVEmulatorSystemsConfiguration.h"
#import "PVRemoteControllerViewController.h"

@import VirtualGameController;
@import GameController;

@interface PVMainViewController ()

@end

@implementation PVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foundService:) name:@"VgcPeripheralFoundService" object:nil];
    
    [VgcManager startAs:AppRolePeripheral appIdentifier:@"provenance" includesPeerToPeer: true];
    DeviceInfo * deviceInfo = [[DeviceInfo alloc] initWithDeviceUID:@"" vendorName:@"" attachedToDevice:NO profileType:ProfileTypeExtendedGamepad controllerType:ControllerTypeSoftware supportsMotion:NO];
    [[VgcManager peripheral] setDeviceInfo:deviceInfo];
    
    [[VgcManager peripheral] browseForServices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonTapped:(id)sender;
{
    NSString *systemID = PVSNESSystemIdentifier;
    
    NSArray *controlLayout = [[PVEmulatorSystemsConfiguration sharedInstance] controllerLayoutForSystem:systemID];
    PVRemoteControllerViewController *controller = [[PVRemoteControllerViewController alloc] initWithControlLayout:controlLayout systemIdentifier:systemID];
    controller.peripheral = [VgcManager peripheral];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) foundService:(NSNotification *) aNotification {
    
    VgcService * service = (VgcService *)[aNotification object];
    NSLog(@"Found service: %@ and automatically connecting to it", service.fullName);
    
    [[VgcManager peripheral] connectToService:service];
    
}


@end
