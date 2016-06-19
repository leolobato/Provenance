//
//  PVEmulatorSystemsConfiguration.h
//  Provenance
//
//  Created by Leonardo Lobato on 19/06/16.
//  Copyright © 2016 James Addyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVEmulatorSystemsConfiguration : NSObject

@property (nonatomic, strong, readonly) NSArray *systems;

+ (instancetype)sharedInstance;

- (NSDictionary *)systemForIdentifier:(NSString *)systemID;
- (NSArray *)availableSystemIdentifiers;
- (NSString *)nameForSystemIdentifier:(NSString *)systemID;
- (NSString *)shortNameForSystemIdentifier:(NSString *)systemID;
- (NSArray *)supportedFileExtensions;
- (NSArray *)supportedCDFileExtensions;
- (NSArray *)cdBasedSystemIDs;
- (NSArray *)fileExtensionsForSystemIdentifier:(NSString *)systemID;
- (NSString *)systemIdentifierForFileExtension:(NSString *)fileExtension;
- (NSArray *)systemIdentifiersForFileExtension:(NSString *)fileExtension;
- (NSArray *)controllerLayoutForSystem:(NSString *)systemID;
- (NSString *)databaseIDForSystemID:(NSString *)systemID;

@end
