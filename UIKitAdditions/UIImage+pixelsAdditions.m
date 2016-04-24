//
//  UIImage+pixelsAdditions.m
//  ColorReader
//
//  Created by Denis Martin on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+pixelsAdditions.h"
#import "UIColor+convertAddition.h"

@implementation UIImage (pixelsAdditions)

- (UIColor*)getRGBAatPoint:(CGPoint)point {
    
    UIColor *result = nil;
    
    // First get the image into your data buffer
    CGImageRef imageRef = [self CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSInteger byteIndex = (bytesPerRow * point.y) + point.x * bytesPerPixel;
    
    CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
    CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
    CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
    CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
//    byteIndex += 4;
    
    result =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    free(rawData);
    
    return result;
}

- (CGPoint)whitePoint {
    
    NSUInteger kWidth   = self.size.width;
    NSUInteger kHeight  = self.size.height;

    CGPoint     whiteP      = CGPointZero;
    CGFloat     whitAdd     = 0.0; /// Highest would be  3.0 * 255.0;
    
    // First get the image into your data buffer
    CGImageRef imageRef = [self CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = malloc(height * width * 4);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, 
                                                 width, 
                                                 height,
                                                 bitsPerComponent, 
                                                 bytesPerRow, 
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
            
    for (NSUInteger x = 0; x < kWidth; x++) {
        for (NSUInteger y = 0; y < kHeight; y++) {
            
            CGPoint checkPoint = CGPointMake(x, y);
            
            // Now your rawData contains the image data in the RGBA8888 pixel format.
            NSUInteger byteIndex = (bytesPerRow * checkPoint.y) + checkPoint.x * bytesPerPixel;
            
            CGFloat red   = (rawData[byteIndex]     * 1.0);
            CGFloat green = (rawData[byteIndex + 1] * 1.0);
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0);
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0);
//            byteIndex += 4;

            CGFloat total = (red + green + blue)*alpha;
            
            if (total > whitAdd) {
                whitAdd = total;
                whiteP = checkPoint;
            }
        }
    }
    
    free(rawData);

    return whiteP;
}

@end
