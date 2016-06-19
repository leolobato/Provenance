//
//  PVRemoteControllerViewController.m
//  Provenance
//
//  Created by Leonardo Lobato on 19/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "PVRemoteControllerViewController.h"

@implementation PVRemoteControllerViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    for (JSButton *button in [self.buttonGroup subviews])
    {
        if (![button isMemberOfClass:[JSButton class]])
        {
            continue; // skip over the PVButtonGroupOverlayView
        }
        
        if ([[[button titleLabel] text] isEqualToString:@"A"])
        {
            [button setTag:4];
        }
        else if ([[[button titleLabel] text] isEqualToString:@"B"] || [[[button titleLabel] text] isEqualToString:@"1"])
        {
            [button setTag:5];
        }
        else if ([[[button titleLabel] text] isEqualToString:@"X"] || [[[button titleLabel] text] isEqualToString:@"2"])
        {
            [button setTag:6];
        }
        else if ([[[button titleLabel] text] isEqualToString:@"Y"])
        {
            [button setTag:7];
        }
    }
    
    [self.leftShoulderButton setTag:8];
    [self.rightShoulderButton setTag:9];
    [self.startButton setTag:10];
    [self.selectButton setTag:11];
}


- (Element *)buttonForTag:(NSInteger)tag;
{
    Element *element = nil;
    switch (tag) {
        case 4:
            element = [[VgcManager elements] buttonA];
            break;
        case 5:
            element = [[VgcManager elements] buttonB];
            break;
        case 6:
            element = [[VgcManager elements] buttonX];
            break;
        case 7:
            element = [[VgcManager elements] buttonY];
            break;
        case 8:
            element = [[VgcManager elements] leftShoulder];
            break;
        case 9:
            element = [[VgcManager elements] rightShoulder];
            break;
        case 10:
            element = [[VgcManager elements] pauseButton];
            break;
    }
    return element;
}

- (void)press:(BOOL)pressed button:(Element *)element;
{
    element.value = pressed ? @1.0f : @0.0f;
    [self.peripheral sendElementState:element];
}


#pragma mark - Controller handling

- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
    switch (direction) {
        case JSDPadDirectionUpLeft:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            element = [[VgcManager elements] dpadYAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionUp:
        {
            Element *element = [[VgcManager elements] dpadYAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionUpRight:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            element = [[VgcManager elements] dpadYAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionLeft:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionNone:
            break;
        case JSDPadDirectionRight:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionDownLeft:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            element = [[VgcManager elements] dpadYAxis];
            element.value = @-1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionDown:
        {
            Element *element = [[VgcManager elements] dpadYAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
        case JSDPadDirectionDownRight:
        {
            Element *element = [[VgcManager elements] dpadXAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            element = [[VgcManager elements] dpadYAxis];
            element.value = @1.0f;
            [self.peripheral sendElementState:element];
            break;
        }
    }

}

- (void)dPadDidReleaseDirection:(JSDPad *)dPad
{
    Element *element = [[VgcManager elements] dpadXAxis];
    element.value = @0.0f;
    [self.peripheral sendElementState:element];
    element = [[VgcManager elements] dpadYAxis];
    element.value = @0.0f;
    [self.peripheral sendElementState:element];
}

- (void)buttonPressed:(JSButton *)button
{
    Element *element = [self buttonForTag:button.tag];
    if (element) {
        [self press:YES button:element];
    }
}

- (void)buttonReleased:(JSButton *)button
{
    Element *element = [self buttonForTag:button.tag];
    if (element) {
        [self press:NO button:element];
    }
}

- (void)pressStartForPlayer:(NSUInteger)player
{
    [self press:YES button:[[VgcManager elements] pauseButton]];
}

- (void)releaseStartForPlayer:(NSUInteger)player
{
    [self press:NO button:[[VgcManager elements] pauseButton]];
}

- (void)pressSelectForPlayer:(NSUInteger)player
{
}

- (void)releaseSelectForPlayer:(NSUInteger)player
{
}

@end
