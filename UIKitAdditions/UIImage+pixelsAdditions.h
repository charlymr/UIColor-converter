//
//  UIImage+pixelsAdditions.h
//  ColorReader
//
//  Created by Denis Martin on 29/05/2011.
//  Copyright 2011 Denis Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (pixelsAdditions)

- (UIColor*)getRGBAatPoint:(CGPoint)point;

@property (readonly) CGPoint whitePoint;

@end
