//
//  ViewController.m
//  FIS-Image-Properties
//
//  Created by Flatiron on 10/20/15.
//  Copyright © 2015 Flatiron. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/CGImageProperties.h>
#import <ImageIO/CGImageSource.h>


@interface ViewController ()
@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *imageWidthLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageHeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // image moca.jpg from assets folder, compressed, looses some data:
//    self.image = [UIImage imageNamed:@"moca.jpg"];
//    NSData *dataMoca = UIImageJPEGRepresentation (self.image,0.5);
//
//    [self logMetaDataFromImage:self.image];
//    [self logMetaDataFromData:dataMoca];
    

    
    
    
    // a google map image, set to imageView:
    
//    NSURL *url = [NSURL URLWithString:@"https://storage.googleapis.com/static.panoramio.com/photos/medium/114911679.jpg"];
//    
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:data];
//    [self logMetaDataFromData:data];
//    [self logMetaDataFromImage:image];
//    
//    [self.imageView setImage:image];
    
    
    
    // a google image
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL* url = [NSURL URLWithString:@"https://storage.googleapis.com/static.panoramio.com/photos/medium/114911679.jpg"];
//        [self logMetaDataFromURL:url];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//    // [self logMetaDataFromData:data];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIImage *image = [[UIImage alloc] initWithData:data];
//        self.image = image;
//        [self logMetaDataFromImage:image];
//        NSLog (@"image.imageOrientation %ld", (long)self.image.imageOrientation);
//    });
//    });
  
    
    
    

    // 1. image from my bundle. from my phone's camera with disabled GEO tagging
//        NSURL *urlOfImage = [[NSBundle mainBundle] URLForResource:@"IMAG0201" withExtension:@"jpg"];
    
    
    // 2. image from google maps
//        NSURL *urlOfImage = [NSURL URLWithString:@"https://storage.googleapis.com/static.panoramio.com/photos/medium/114911679.jpg"];
    
    
    // 3. image from my bundle. that was taken through instagram
    NSURL *urlOfImage = [[NSBundle mainBundle] URLForResource:@"IMG_20150822_121456" withExtension:@"jpg"];

    
    NSData *jpegData = [NSData dataWithContentsOfURL:urlOfImage];
    [self logMetaDataFromData:jpegData];
    
    //convert data back to image:
    UIImage *theActualImage = [UIImage imageWithData:jpegData];
    [self logMetaDataFromImage:theActualImage];

    CGImageSourceRef imageData= CGImageSourceCreateWithData((CFDataRef)jpegData, NULL);
    NSDictionary *metadata = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageData, 0, NULL);
    NSDictionary *exifGPSDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    [self.imageView setImage:theActualImage];

    
    if(exifGPSDictionary) {
        NSLog(@"WOO! %@", exifGPSDictionary);
    }
    
    
    

    
    
    //Text Labels:
    
    self.imageWidthLabel.text = [NSString stringWithFormat:@"height: %lu px", (NSUInteger)theActualImage.size.width];
    self.imageHeightLabel.text = [NSString stringWithFormat:@"width: %lu px", (NSUInteger)theActualImage.size.height];

    NSNumber *latitude = [exifGPSDictionary objectForKey:@"Latitude"];
    self.latitudeLabel.text = [NSString stringWithFormat:@"latitude: %@", latitude];
    
    NSNumber *longitude = [exifGPSDictionary objectForKey:@"Longitude"];
    self.longitudeLabel.text = [NSString stringWithFormat:@"longitude: %@", longitude];
    
}
    







- (void) logMetaDataFromData:(NSData*)data
{
    NSLog(@" %@",NSStringFromSelector(_cmd));
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSLog (@"%@",imageMetaData);
}




- (void) logMetaDataFromImage:(UIImage*)image
{
    NSLog(@" %@",NSStringFromSelector(_cmd));
    NSData *jpegData = UIImageJPEGRepresentation(image, 1.0);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpegData, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSLog (@"%@",imageMetaData);
}





- (void) logMetaDataFromURL:(NSURL*)URL
{
    NSLog(@" %@",NSStringFromSelector(_cmd));
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)URL, NULL);
    CFDictionaryRef imageMetaData = CGImageSourceCopyPropertiesAtIndex(source,0,NULL);
    NSLog (@"%@",imageMetaData);
}





-(NSDictionary *)locationInfoFromImageURL:(NSURL *)URL
{
    NSData *jpegData = [NSData dataWithContentsOfURL:URL];
    
    CGImageSourceRef imageData= CGImageSourceCreateWithData((CFDataRef)jpegData, NULL);
    NSDictionary *metadata = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageData, 0, NULL);
    NSDictionary *exifGPSDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    return exifGPSDictionary;
}





-(NSDictionary *)locationInfoFromImage:(UIImage *)image
{
    UIImage *anImage = [UIImage imageNamed:@"image"];
    NSData *jpegData = UIImageJPEGRepresentation(anImage, 1);
    
    CGImageSourceRef imageData= CGImageSourceCreateWithData((CFDataRef)jpegData, NULL);
    NSDictionary *metadata = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imageData, 0, NULL);
    NSDictionary *exifGPSDictionary = [metadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    
    return exifGPSDictionary;
}





/*
 
 RELATED METHODS TO LOOK UP:
 
 CLLocationManager *locationManager = [[CLLocationManager alloc] init];
 kCGImagePropertyGPSSpeed;
 kCGImagePropertyGPSTrack;
 
 locationManager.location
 
 NSMetadataItemURLKey;
 NSMetadataItem;
 
 */







@end
