//
//  PVControllerSelectionViewController.m
//  Provenance
//
//  Created by James Addyman on 19/09/2015.
//  Copyright © 2015 James Addyman. All rights reserved.
//

#import "PVControllerSelectionViewController.h"
#import "PVControllerManager.h"

@interface PVControllerSelectionViewController ()

@end

@implementation PVControllerSelectionViewController

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleControllerReassigned:)
                                                 name:PVControllerManagerControllerReassignedNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:PVControllerManagerControllerReassignedNotification
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

#if TARGET_OS_TV
    [self.splitViewController setTitle:@"Controller Settings"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:nil];
#else
    [self setTitle:@"Controller Settings"];
#endif
}

- (void)handleControllerReassigned:(NSNotification *)notification;
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[PVControllerManager sharedManager] maxControllers];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"controllerCell"];
    
    NSInteger player = [indexPath row] + 1;
    
    [cell.textLabel setText:[NSString stringWithFormat:@"Player %@", [NSNumber numberWithInteger:player]]];
    GCController *controller = [[PVControllerManager sharedManager] controllerForPlayer:player];
    if (controller)
    {
        [cell.detailTextLabel setText:[controller vendorName]];
    }
    else
    {
        [cell.detailTextLabel setText:@"None Selected"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Controller Assignment";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Select a controller for Player %zd", ([indexPath row] + 1)]
                                                                         message:@""
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    if ([self.traitCollection userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [[actionSheet popoverPresentationController] setSourceView:self.tableView];
        [[actionSheet popoverPresentationController] setSourceRect:[self.tableView rectForRowAtIndexPath:indexPath]];
    }

    NSInteger player = [indexPath row]+1;
    NSArray *assignedControllers = [[PVControllerManager sharedManager] sortedControllers];
    for (GCController *controller in [GCController controllers])
    {
        NSString *title = [controller vendorName];
        if ([assignedControllers containsObject:controller])
        {
            title = [title stringByAppendingString:[NSString stringWithFormat:@" (Player %@)", [NSNumber numberWithInteger:controller.playerIndex+1]]];
        }

        [actionSheet addAction:[UIAlertAction actionWithTitle:title
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [[PVControllerManager sharedManager] setController:controller toPlayer:player];

                                                          [self.tableView reloadData];
                                                      }]];
    }

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Not Playing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[PVControllerManager sharedManager] setController:nil toPlayer:player];

        [self.tableView reloadData];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];



    [self presentViewController:actionSheet animated:YES completion:NULL];
}

@end
