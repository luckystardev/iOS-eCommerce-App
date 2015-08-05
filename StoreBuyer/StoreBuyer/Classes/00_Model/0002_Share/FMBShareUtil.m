//
//  FMBShareUtil.m
//  StoreBuyer
//
//  Created by Matti on 9/29/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBShareUtil.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBThemeManager.h"

@implementation FMBShareUtil

// --------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
+ (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBShareUtil) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

// --------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
+ (NSString *)imageUrlFromProduct:(PFObject *)product
{
    PFFile *file =  product[kFMProductImagesKey][0];
    return file.url;
}

+ (NSData *)imageDataFromProduct:(PFObject *)product
{
    PFFile *file =  product[kFMProductImagesKey][0];
    return [file getData];
}
// --------------------------------------------------------------------------------------------------------------
#pragma mark - Facebook Share Functions
+ (NSDictionary *)shareParamsForFacebookWithProduct:(PFObject *)product
{
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                product[kFMProductTitleKey],        @"name",
                                @"",                                @"caption",
                                product[kFMProductDescriptionKey],  @"description",
                                @"chengxian-store.com",             @"link",
                                [self imageUrlFromProduct:product], @"picture",
                                nil];
    
    return res;
}

+ (void)shareViaFacebookWithProduct:(PFObject *)product delegate:(id<FMBShareUtilDelegate>)delegate
{
    [self printLogWith:@"shareViaFacebookWithProduct"];
    
    NSDictionary *params = [self shareParamsForFacebookWithProduct:product];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error)
         {
             // Error launching the dialog or publishing a story.
             [self printLogWith:[error localizedDescription]];
         }
         else
         {
             if (result == FBWebDialogResultDialogNotCompleted)
             {
                 // User clicked the "x" icon
                 [self printLogWith:@"User canceled story publishing."];
             }
             else
             {
                 // Handle the publish feed callback
                 [delegate shareUtilDelegateDidCompleteShare];
             }
         }
     }];
}

// --------------------------------------------------------------------------------------------------------------
#pragma mark - Email Share Functions
+ (MFMailComposeViewController *)shareViaEmailWithProduct:(PFObject *)product delegate:(id)delgate
{
    [self printLogWith:@"shareViaEmailWithProduct"];
    
    NSString *title = product[kFMProductTitleKey];
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = delgate;
    [picker setSubject:title];
    
    NSData *myData = [self imageDataFromProduct:product];
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:[NSString stringWithFormat:@"%@.png", title]];
    
    // Fill out the email body text
    NSString *emailBody = product[kFMProductDescriptionKey];
    [picker setMessageBody:emailBody isHTML:NO];
    
    return picker;
}

@end
