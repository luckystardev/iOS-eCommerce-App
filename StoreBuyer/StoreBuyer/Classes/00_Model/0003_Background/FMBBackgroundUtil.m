//
//  FMBBackgroundUtil.m
//  StoreBuyer
//
//  Created by Matti on 10/7/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBBackgroundUtil.h"
#import "FMBConstants.h"
#import "FMBData.h"
#import "FMBUtil.h"
#import "FMBBackgroundSetting.h"

@implementation FMBBackgroundUtil

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBBackgroundUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)imagePathDir
{
    NSString *imageDir = [NSString stringWithFormat:@"%@/Documents/Images", NSHomeDirectory()];
    return imageDir;
}

+ (NSDictionary *)notificationObjectWithImage:(UIImage *)image forBackgroundName:(NSString *)backgroundName
{
    NSDictionary *res = @{kFMBackgroundNameKey:backgroundName, kFMBackgroundImageKey:image};
    return res;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Image Functions
+ (UIImage *)resizeImage:(UIImage *)image
{
    [self printLogWith:@"productImageFromImage"];
    
    // Check image width or height overflows the size
    //    if ([FMBUtil checkImage:image outOfSize:size])
    //    {
    //        return [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
    //                                           bounds:size
    //                             interpolationQuality:kCGInterpolationMedium];
    //    }
    
    return image;
}

// -------------------------------------------------------------------------------------------------------------------
#pragma mark - Request Functions
+ (void)requestBackgroundForName:(NSString *)backgroundName delegate:(id<FMBBackgroundUtilDelegate>)delegate
{
    [self printLogWith:@"requestBackgroundImageForName"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMBackgroundClassKey];
    [query whereKey:kFMBackgroundNameKey equalTo:backgroundName];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             PFObject *object = objects[0];
             
             PFFile *file = object[kFMBackgroundImageKey];
             
             FMBBackgroundSetting *setting = [FMBBackgroundSetting sharedInstance];
             
             if ([setting checkFileName:file.name forBackgroundName:backgroundName])
             {
                 UIImage *res = [setting imageForBackgroundName:backgroundName];
                 [delegate requestBackgroundForNameDidRespondWithImage:res isNew:NO];
             }
             else
             {
                 [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
                  {
                      if (error)
                      {
                          [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
                      }
                      else
                      {
                          UIImage *res = [UIImage imageWithData:data];
                          [setting saveImage:res withFileName:file.name forBackgroundName:backgroundName];
                          [delegate requestBackgroundForNameDidRespondWithImage:res isNew:YES];
                      }
                  }];
             }
         }
     }];
}

@end
