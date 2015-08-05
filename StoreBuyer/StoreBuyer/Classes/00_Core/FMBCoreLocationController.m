//
//  FMBCoreLocationController.m
//  StoreBuyer
//
//  Created by Matti on 9/24/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBCoreLocationController.h"
#import "FMBData.h"
#import "FMBUtil.h"
#import "FMBConstants.h"
#import "LMGeocoder.h"

// Interval in seconds to check if need to sync (keeps checking at this interval until successful sync)
#define CHECK_INTERVAL 600.0

@implementation FMBCoreLocationController

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBCoreLocationController) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark - LifeCycle Functions
- (id)init
{
    [self printLogWith:@"init"];
    
    self = [super init];
    
    if(self != nil)
    {
    }
    
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ---------------------------------------------------------------------------------------------------------------------------
#pragma mark -
- (void)startUpdateLocation
{
    [self printLogWith:@"startUpdateLocation"];
    
    [self runLocationManager:nil];
    [self start];
}

- (void)stopUptateLocation
{
    [self printLogWith:@"stopUptateLocation"];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)start
{
    [self printLogWith:@"start"];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:CHECK_INTERVAL
                                                  target:self
                                                selector:@selector(runLocationManager:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)runLocationManager:(id)sender
{
    [self printLogWith:@"runLocationManager"];
 
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error)
    {
        if (error)
        {
            [self.delegate locationError:error];
        }
        else
        {
            [self.delegate locationUpdateWithGeoPoint:geoPoint];
        }
    }];
}

@end
