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

@interface PVMainViewController ()

@end

@implementation PVMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self.navigationController pushViewController:controller animated:YES];
}

@end
