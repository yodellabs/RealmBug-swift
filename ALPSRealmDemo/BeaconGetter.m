//
//  BeaconGetter.m
//  ALPSRealmDemo
//
//  Created by Nick Wilkerson on 12/11/17.
//  Copyright © 2017 Yodel Labs. All rights reserved.
//

#import "BeaconGetter.h"
#import <ALPS/ALPS.h>
#import <ALPS/ALPSStoredBeacon.h>


@implementation BeaconGetter
-(void)connectAndFindBeacons {
    NSURL *webServerURL = [NSURL URLWithString: @"https://realm.yodellabs.com"];
    NSLog(@"web server url: %@", webServerURL);
    NSURLComponents *components = [NSURLComponents componentsWithURL:webServerURL resolvingAgainstBaseURL:YES];
    components.scheme = @"realms";
    NSURL *realmServerURL = components.URL;
    NSString *remoteRealmIdentifier = @"/e556ef2b8765f15529ad4ffe15a04a73/facebook";
    
    
    RLMSyncCredentials *usernameCredentials = [RLMSyncCredentials credentialsWithUsername:@"user"
                                                                                 password:@"yodel"
                                                                                 register:NO];
    [RLMSyncUser logInWithCredentials:usernameCredentials
                        authServerURL:webServerURL
                         onCompletion:^(RLMSyncUser *user, NSError *error) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 if (user) {
                                     RLMSyncUser *user = [RLMSyncUser currentUser];
                                     NSURL *remoteRealmURL = [realmServerURL URLByAppendingPathComponent:remoteRealmIdentifier];
                                     RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];

                                     NSLog(@"logged in user: %@", user);
                                     NSLog(@"remoteRealmURL: %@", remoteRealmURL.absoluteString);
                                     config.syncConfiguration = [[RLMSyncConfiguration alloc] initWithUser:user realmURL:remoteRealmURL];
                                     [RLMRealm asyncOpenWithConfiguration:config callbackQueue:dispatch_get_main_queue() callback:^(RLMRealm *realm, NSError *error) {
                                         NSLog(@"returned realm: %@", realm);
                                         if (error) {
                                             NSLog(@"Error connecting to remote realm identified by %@: %@", remoteRealmIdentifier, error.localizedDescription);
                                             return;
                                         }
                                         NSArray *beacons = [self findAllRemoteBeaconsInRealm:realm];
                                         NSLog(@"number of beacons: %lu", (unsigned long)beacons.count);
                                         
                                     }];
                                     
                                 } else if (error) {
                                     NSLog(@"error loggin in: %@", error.localizedDescription);
                                 }
                             });
                         }];
}

-(NSArray *)findAllRemoteBeaconsInRealm:(RLMRealm *)realm {
    NSLog(@"connected remote realm: %@", realm);
    RLMResults *results = [ALPSStoredBeacon allObjectsInRealm:realm];
    NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
    for (ALPSStoredBeacon *beacon in results) {
        [resultsArray addObject:beacon];
    }
    return resultsArray;
}
@end
