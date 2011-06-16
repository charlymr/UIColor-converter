//
//  ColorConverterAppDelegate.m
//  ColorConverter
//
//  Created by Denis Martin on 16/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ColorConverterAppDelegate.h"

#import "UIColor+convertAddition.h"
#import "UIImage+pixelsAdditions.h"


@implementation ColorConverterAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIImage *testImage = [UIImage imageNamed:@"testImageWat7x7"];
    CGPoint whitePoint = testImage.whitePoint;
    NSLog(@"testImageWat7x7 whitePoint : CGPoint(%.f,%.f)", whitePoint.x, whitePoint.y);
    
    UIColor *aColor = [UIColor blueColor];
    
    NSLog(@"%@", [aColor formatedTextForMode:kShowRGB]);
    NSLog(@"%@", [aColor formatedTextForMode:kShowCMYK]);
    NSLog(@"%@", [aColor formatedTextForMode:kShwowHsb]);
    NSLog(@"%@", [aColor formatedTextForMode:kShowCIExyz]);
    NSLog(@"%@", [aColor formatedTextForMode:kShowHBWLum]);

    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc {
    [_window release];
    [super dealloc];
}

@end
