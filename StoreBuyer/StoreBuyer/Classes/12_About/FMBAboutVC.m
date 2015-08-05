//
//  FMBAboutVC.m
//  StoreBuyer
//
//  Created by Matti on 10/18/14.
//  Copyright (c) 2014 Matti. All rights reserved.
//

#import "FMBAboutVC.h"
#import "FMBData.h"
#import "FMBConstants.h"
#import "FMBUtil.h"
#import "FMBThemeManager.h"
#import "FMBBackgroundSetting.h"

@interface FMBAboutVC ()

@end

@implementation FMBAboutVC
{
    PFObject *companyProfile;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Basic Functions
- (void)printLogWith:(NSString *)logMessage
{
    if (!debug || !debugFMBAboutVC) return;
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@", self.class, logMessage];
    
    NSLog(@"%@", logString);
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    [self printLogWith:@"initWithCoder"];
    
    if ((self = [super initWithCoder:aDecoder]))
    {
    }
    return self;
}

- (void)dealloc
{
    [self printLogWith:@"dealloc"];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - View LifeCycle Functions
- (void)viewDidLoad
{
    [self printLogWith:@"viewDidLoad"];
    [super viewDidLoad];
    
    [self initUI];
    [self initContents];
}

- (void)didReceiveMemoryWarning
{
    [self printLogWith:@"didReceiveMemoryWarning"];
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Utility Functions
- (void)initUI
{
    [self printLogWith:@"initUI"];
    
    [self initTheme];
    [self initViewBackground];
}

- (void)initTheme
{
    [self printLogWith:@"initTheme"];
    
    _textviewCompanyDescription.backgroundColor = RGBHEX(0x000000, .2f);
}

- (void)initViewBackground
{
    [self printLogWith:@"initViewBackground"];
    
    _imageviewBackground = [FMBThemeManager createBackgroundImageViewForTableVC:self withBottomBar:nil];
    [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    
    [FMBBackgroundUtil requestBackgroundForName:kFMBackgroundNameSettings delegate:self];
}

- (void)initContents
{
    [self printLogWith:@"initContents"];
    
    PFQuery *query = [PFQuery queryWithClassName:kFMCompanyClassKey];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error)
         {
             [self printLogWith:[FMBUtil errorStringFromParseError:error WithCode:YES]];
         }
         else
         {
             companyProfile = objects[0];
             [self setContentFromObject:objects[0]];
         }
     }];
}

- (void)setContentFromObject:(PFObject *)object
{
    [self printLogWith:@"setContentFromObject"];
    
    _labelCompanyName.text              = object[kFMCompanyNameKey];
    _labelCompanySlogan.text            = @"Company Slogan";
    //    _textviewCompanyDescription.text    = @"Compnay Description";
    _labelOpenHour.text                 = object[kFMCompanyOpenHourKey];
    _labelCloseHour.text                = object[kFMCompanyCloseHourKey];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - FMABackgroundUtilDelegate
- (void)requestBackgroundForNameDidRespondWithImage:(UIImage *)image isNew:(BOOL)bNew
{
    [self printLogWith:@"requestBackgroundForNameDidRespondWithImage"];
    
    if (bNew)
    {
        [FMBThemeManager setBackgroundImageForName:kFMBackgroundNameSettings toImageView:_imageviewBackground];
    }
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Button Events Functions
- (IBAction)onBtnMenu:(id)sender
{
    [self printLogWith:@"onBtnMenu"];
    
    [self.sideMenuViewController openMenuAnimated:YES completion:nil];
}

- (IBAction)onBtnFindUs:(id)sender
{
    [self printLogWith:@"onBtnFindUs"];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:@"1326 Pearl Street, Boulder, Colorado, United States"
                 completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error)
         {
             NSLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = placemarks[0];
             CLLocation *location = placemark.location;
             CLLocationCoordinate2D coords = location.coordinate;
             
             // Get Destination MapItem
             MKPlacemark *place4Destination = [[MKPlacemark alloc]
                                               initWithCoordinate:coords addressDictionary:placemark.addressDictionary];
             
             MKMapItem *mapItem4Destination = [[MKMapItem alloc]
                                               initWithPlacemark:place4Destination];
             mapItem4Destination.name = @"Artmart Gifts";
             
             //             NSDictionary *options = @{
             //                                       MKLaunchOptionsDirectionsModeKey:    MKLaunchOptionsDirectionsModeWalking,
             //                                       MKLaunchOptionsMapTypeKey:           [NSNumber numberWithInteger:MKMapTypeStandard],
             //                                       MKLaunchOptionsShowsTrafficKey:      @NO
             //                                       };
             
             [mapItem4Destination openInMapsWithLaunchOptions:nil];
             
             
             //             // Get MapItem For Current Location
             //             MKMapItem *mapItem4CurrentLocation = [MKMapItem mapItemForCurrentLocation];
             //             //                 [mapItem4CurrentLocation openInMapsWithLaunchOptions:nil];
             //
             //             // Show Directions Form Current Location to Destination
             //             NSArray *mapItems = @[mapItem4CurrentLocation, mapItem4Destination];
             //
             //
             //             [MKMapItem openMapsWithItems:mapItems launchOptions:options];
         }
     }
     ];
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - MKMapViewDelegate
//- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
//
//    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
//
//    if (annotationView == nil)
//    {
//        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier] autorelease];
//    }
//
//    // here you can assign your friend's image
//    annotationView.image = [UIImage imageNamed:@"friend_image.png"];
//    annotationView.annotation = annotation;
//    
//    // add below line of code to enable selection on annotation view
//    annotationView.canShowCallout = YES
//    
//    return annotationView;
//}

@end
