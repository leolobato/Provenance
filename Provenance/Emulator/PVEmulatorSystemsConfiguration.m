//
//  PVEmulatorSystemsConfiguration.m
//  Provenance
//
//  Created by Leonardo Lobato on 19/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import "PVEmulatorSystemsConfiguration.h"

#import "PVEmulatorConstants.h"

@interface PVEmulatorSystemsConfiguration ()

@property (nonatomic, strong, readwrite) NSArray *systems;

@end

@implementation PVEmulatorSystemsConfiguration

+ (instancetype)sharedInstance
{
    static id _sharedInstance;
    
    if (!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
}


- (id)init
{
    if ((self = [super init]))
    {
        self.systems = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"systems" ofType:@"plist"]];
    }
    
    return self;
}


- (NSDictionary *)systemForIdentifier:(NSString *)systemID
{
    for (NSDictionary *system in self.systems)
    {
        if ([[system objectForKey:PVSystemIdentifierKey] isEqualToString:systemID])
        {
            return system;
        }
    }
    
    return nil;
}

- (NSArray *)availableSystemIdentifiers
{
    NSMutableArray *systemIDs = [NSMutableArray array];
    
    for (NSDictionary *system in self.systems)
    {
        NSString *systemID = [system objectForKey:PVSystemIdentifierKey];
        [systemIDs addObject:systemID];
    }
    
    return [systemIDs copy];
}

- (NSString *)nameForSystemIdentifier:(NSString *)systemID
{
    NSDictionary *system = [self systemForIdentifier:systemID];
    return [system objectForKey:PVSystemNameKey];
}

- (NSString *)shortNameForSystemIdentifier:(NSString *)systemID
{
    NSDictionary *system = [self systemForIdentifier:systemID];
    return [system objectForKey:PVShortSystemNameKey];
}

- (NSArray *)supportedCDFileExtensions
{
    NSMutableSet *extensions = [NSMutableSet set];
    
    for (NSDictionary *system in self.systems)
    {
        if (system[PVUsesCDsKey])
        {
            [extensions addObjectsFromArray:system[PVSupportedExtensionsKey]];
        }
    }
    
    return [extensions allObjects];
}

- (NSArray *)cdBasedSystemIDs
{
    NSMutableSet *systems = [NSMutableSet set];
    
    for (NSDictionary *system in self.systems)
    {
        if (system[PVUsesCDsKey])
        {
            [systems addObject:system[PVSystemIdentifierKey]];
        }
    }
    
    return [systems allObjects];
}

- (NSArray *)supportedFileExtensions
{
    NSMutableSet *extentions = [NSMutableSet set];
    
    for (NSDictionary *system in self.systems)
    {
        NSArray *ext = [system objectForKey:PVSupportedExtensionsKey];
        [extentions addObjectsFromArray:ext];
    }
    
    return [extentions allObjects];
}

- (NSArray *)fileExtensionsForSystemIdentifier:(NSString *)systemID
{
    NSDictionary *system = [self systemForIdentifier:systemID];
    return [system objectForKey:PVSupportedExtensionsKey];
}

- (NSString *)systemIdentifierForFileExtension:(NSString *)fileExtension
{
    for (NSDictionary *system in self.systems)
    {
        NSArray *supportedFileExtensions = [system objectForKey:PVSupportedExtensionsKey];
        if ([supportedFileExtensions containsObject:[fileExtension lowercaseString]])
        {
            return [system objectForKey:PVSystemIdentifierKey];
        }
    }
    
    return nil;
}

- (NSArray *)systemIdentifiersForFileExtension:(NSString *)fileExtension
{
    NSMutableArray *systems = [NSMutableArray array];
    for (NSDictionary *system in self.systems)
    {
        NSArray *supportedFileExtensions = [system objectForKey:PVSupportedExtensionsKey];
        if ([supportedFileExtensions containsObject:[fileExtension lowercaseString]])
        {
            [systems addObject:[system objectForKey:PVSystemIdentifierKey]];
        }
    }
    
    return [systems copy];
}

- (NSArray *)controllerLayoutForSystem:(NSString *)systemID
{
    NSDictionary *system = [self systemForIdentifier:systemID];
    return [system objectForKey:PVControlLayoutKey];
}

- (NSString *)databaseIDForSystemID:(NSString *)systemID
{
    NSDictionary *system = [self systemForIdentifier:systemID];
    return system[PVDatabaseIDKey];
}

@end
