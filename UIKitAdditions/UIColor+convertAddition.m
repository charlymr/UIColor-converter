//
//  UIColor+HSBColorAddition.m
//
//  Created by Denis Martin on 20/05/2011.
//  Copyright 2011 Denis Martin . All rights reserved.
//

#import "UIColor+convertAddition.h"

@interface HSBColor : NSObject

@property (readwrite) CGFloat       hue;
@property (readwrite) CGFloat       saturation;
@property (readwrite) CGFloat       brightness;

+(HSBColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b;

+(HSBColor*)colorWithSystemColor:(UIColor*)color;

@end

@interface CIExyzColor : NSObject

@property (readwrite) CGFloat       xCIE;
@property (readwrite) CGFloat       yCIE;
@property (readwrite) CGFloat       zCIE;

+(CIExyzColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b;

+(CIExyzColor*)cieXYZcolorWithSystemColor:(UIColor*)color;

@end

@interface CIELabColor : NSObject

@property (readwrite) CGFloat       lCIE;
@property (readwrite) CGFloat       aCIE;
@property (readwrite) CGFloat       bCIE;

+(CIELabColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b WhiteRed:(CGFloat)rW WhiteGreen:(CGFloat)gW WhiteBlue:(CGFloat)bW;

+(CIELabColor*)colorWithSystemColor:(UIColor*)color andWhiteColor:(UIColor*)whitePoint;

@end

//// Utilities class Implementations
@implementation HSBColor : NSObject

//////     http://en.wikipedia.org/wiki/HSL_and_HSV 

+(HSBColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b  {
    HSBColor* toReturn = [[[HSBColor alloc] init] autorelease];

    CGFloat hue, saturation, brigthness;
	CGFloat min, max, delta;
	min = MIN( r, g);
	max = MAX( r, g);
    min = MIN( min, b );
	max = MAX( max, b );
    
    brigthness = max;                    // v
    
	delta = max - min;
	if( max != 0 ) {
		saturation = delta / max;		// s
    } else {
		// r = g = b = 0		// s = 0, v is undefined
		saturation = 0;
		hue = -1;
        toReturn.hue        = hue;
        toReturn.saturation = saturation;
        toReturn.brightness = brigthness;
		return toReturn;
	}
    
	if( r == max )
        hue = ( g - b ) / delta;		// between yellow & magenta
	else if( g == max )
        hue = 2 + ( b - r ) / delta;	// between cyan & yellow
	else
		hue = 4 + ( r - g ) / delta;	// between magenta & cyan
    
	hue *= 60;                         // degrees
    
	if( hue < 0 )
		hue += 360;  
    
    toReturn.hue        = hue;
    toReturn.saturation = saturation;
    toReturn.brightness = brigthness;
    return toReturn;
}

+(HSBColor*)colorWithSystemColor:(UIColor*)color {
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return [self colorWithRed:components[0] Green:components[1] Blue:components[2]];
}

@end

@implementation CIExyzColor : NSObject

// http://en.wikipedia.org/wiki/SRGB_color_space
+(CIExyzColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b  {
    CIExyzColor* toReturn = [[[CIExyzColor alloc] init] autorelease];

    /// official sRGB specification (IEC 61966-2-1:1999)
    CGFloat M[9] =  {       0.4124,  0.3576,  0.1805,
                            0.2126,  0.7152,  0.0722,
                            0.0193,  0.1192,  0.9505    };
    toReturn.xCIE = M[0] * r + M[1] * g + M[2] * b;
    toReturn.yCIE = M[3] * r + M[4] * g + M[5] * b;
    toReturn.zCIE = M[6] * r + M[7] * g + M[8] * b;
    return toReturn;
}

+(CIExyzColor*)cieXYZcolorWithSystemColor:(UIColor*)color {
    const CGFloat* components = CGColorGetComponents(color.CGColor);
    return [self colorWithRed:components[0] Green:components[1] Blue:components[2]];
}

@end

@implementation CIELabColor : NSObject

/// http://en.wikipedia.org/wiki/Lab_color_space 
/// http://en.wikipedia.org/wiki/Lab_color_space
/// http://www.math.ucla.edu/~getreuer/colorspace.html#CIE

/// http://web.jfet.org/color-conversions.html#XYZ%20to%20CIE%20L*a*b*%20(CIELAB)%20&%20CIELAB%20to%20XYZ
/*
 
 XYZ to CIE L*a*b* (CIELAB) & CIELAB to XYZ
 
 CIE 1976 L*a*b* is based directly on CIE XYZ and is an attampt to linearize the perceptibility of color differences. The non-linear relations for L*, a*, and b* are intended to mimic the logarithmic response of the eye. Coloring information is referred to the color of the white point of the system, subscript n.
 
 L = 116 * (Y/Yn)^1/3 - 16    for Y/Yn > 0.008856
 L = 903.3 * Y/Yn             otherwise
 
 a = 500 * ( f(X/Xn) - f(Y/Yn) )
 b = 200 * ( f(Y/Yn) - f(Z/Zn) )
 where f(t) = t^1/3      for t > 0.008856
 f(t) = 7.787 * t + 16/116    otherwise
 
 Here Xn, Yn and Zn are the tristimulus values of the reference white.
 The reverse transformation (for Y/Yn > 0.008856) is
 
 X = Xn * ( P + a / 500 )^3
 Y = Yn * P^3
 Z = Zn * ( P - b / 200 )^3
 where P = (L + 16) / 116
 */

/*
 Xn=95.04;
 Yn=100.00;
 Zn=108.89;
 this also depends on whether you are pursuing absolute or relative 
 colorimetry, relative colorimetry is used in appearance modeling, it is 
 worthwhile to note that absolute colorimetry is NOT appearance, in 
 relative colorimetry, Xn=Yn=Zn=100, always, the reason is that the eye 
 adapts to the white point
 */

#define cieT pow(6.0/29.0, 3)

+(double)functTwithA:(double)a andAn:(double)an {
    if (a/an > cieT) 
        return pow(a/an, 1.0/3.0); 
    else 
        return 1.0/3.0*pow(29.0/6.0, 2)*(a/an) + 4.0/29.0;
}

/// Normal
+(CIELabColor*)colorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b WhiteRed:(CGFloat)rW WhiteGreen:(CGFloat)gW WhiteBlue:(CGFloat)bW  {
    
    CIELabColor* toReturn = [[[CIELabColor alloc] init] autorelease];
    
    UIColor *white = [UIColor colorWithRed:rW green:gW blue:bW alpha:1.0];
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    
    double X     = color.cieX;
    double Y     = color.cieY;
    double Z     = color.cieZ;
    double Xn    = white.cieX;
    double Yn    = white.cieY;
    double Zn    = white.cieZ;

    NSLog(@"CIE ||| X: %.4f, Y: %.4f, Z: %.4f ||| Xn: %.4f, Yn: %.4f, Zn: %.4f, ", X, Y, Z, Xn, Yn, Zn);
    
//  L = 116 * (Y/Yn)^1/3 - 16    for Y/Yn > 0.008856
//  L = 903.3 * Y/Yn             otherwise
    if (Y/Yn > cieT) {
        double yyn13 = pow(Y/Yn, 1.0/3.0);
        NSLog(@"CIE ||| (Y(%.3f)/Yn(%.3f))^(1/3) = %.3f", Y, Yn, yyn13);
        toReturn.lCIE = 116.0 * yyn13 - 16.0;
    } else 
        toReturn.lCIE = 903.3 * Y/Yn;
    
//    a = 500 * ( f(X/Xn) - f(Y/Yn) )
//    b = 200 * ( f(Y/Yn) - f(Z/Zn) )
//    where f(t) = t^1/3      for t > 0.008856
//        f(t) = 7.787 * t + 16/116    otherwise
    
    double fXdXn = [CIELabColor functTwithA:X andAn:Xn];
    double fYdYn = [CIELabColor functTwithA:Y andAn:Yn];
    double fZdZn = [CIELabColor functTwithA:Z andAn:Zn];

    toReturn.aCIE  =  500.0 * (fXdXn - fYdYn);
    toReturn.bCIE  =  200.0 * (fYdYn - fZdZn);
    
    return toReturn;
}

/// Hunter
+(CIELabColor*)labColorWithRed:(CGFloat)r Green:(CGFloat)g Blue:(CGFloat)b {
    
    CIELabColor* toReturn = [[[CIELabColor alloc] init] autorelease];
    
    UIColor *color = [UIColor colorWithRed:r green:g blue:b alpha:1.0];
    
    double X     = color.cieX;
    double Y     = color.cieY;
    double Z     = color.cieZ;
    
    // D65 white point, Xn = 0.950456, Yn = 1, Zn = 1.088754. 
    double Xn=0.950456;
    double Yn=1.0;
    double Zn=1.088754;
    

    double fXdXn = [CIELabColor functTwithA:X andAn:Xn];
    double fYdYn = [CIELabColor functTwithA:Y andAn:Yn];
    double fZdZn = [CIELabColor functTwithA:Z andAn:Zn];
    
    NSLog(@"CIE ||| X: %.4f, Y: %.4f, Z: %.4f ||| Xn: %.4f, Yn: %.4f, Zn: %.4f, ", X, Y, Z, Xn, Yn, Zn);
    
    
    /// Hunter
    double Ka   = (175.0/198.04)*(Xn + Yn);
    double Kb   = (70.0/218.11)*(Yn + Zn);
    toReturn.lCIE = 100.0 * sqrt(fYdYn);
    toReturn.aCIE = Ka *((fXdXn-fYdYn)/sqrt(fYdYn));
    toReturn.bCIE = Kb *((fYdYn-fZdZn)/sqrt(fYdYn));
    
    /// Standard
//    toReturn.lCIE  =  (116.0 * fYdYn) - 16.0;
//    toReturn.aCIE  =  500.0 * (fXdXn - fYdYn);
//    toReturn.bCIE  =  200.0 * (fYdYn - fZdZn);
    return toReturn;
}

+(CIELabColor*)colorWithSystemColor:(UIColor*)color andWhiteColor:(UIColor*)whitePoint {
    const CGFloat* components   = CGColorGetComponents(color.CGColor);
    const CGFloat* componentsW  = CGColorGetComponents(whitePoint.CGColor);

    return [self colorWithRed:components[0] Green:components[1] Blue:components[2] WhiteRed:componentsW[0] WhiteGreen:componentsW[1] WhiteBlue:componentsW[2]];
}

+(CIELabColor*)labColorWithSystemColor:(UIColor*)color {
    const CGFloat* components   = CGColorGetComponents(color.CGColor);
    return [self labColorWithRed:components[0] Green:components[1] Blue:components[2]];
}

@end

@implementation UIColor (RGB_Addition)

-(CGFloat)red {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    CGFloat value   =	components[0];
    return value;
}

-(CGFloat)green {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    CGFloat value   =	components[1];
    return value;
}

-(CGFloat)blue {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    CGFloat value   =	components[2];
    return value;
}

-(CGFloat)alpha {
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    CGFloat value   =	components[3];
    return value;
}

@end

@implementation UIColor (CMYK_Addition)

-(NSUInteger)cyan {
    
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    NSUInteger R = components[0]*255;
    NSUInteger G = components[1]*255;
    NSUInteger B = components[2]*255;
    
    CGFloat k = MIN(255-R,MIN(255-G,255-B));
    CGFloat c = 255*(255-R-k)/(255-k);
    
    return  c * 100 / 255;
}

-(NSUInteger)magenta {
    
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    NSUInteger R = components[0]*255;
    NSUInteger G = components[1]*255;
    NSUInteger B = components[2]*255;
    
    CGFloat k = MIN(255-R,MIN(255-G,255-B));
    CGFloat m = 255*(255-G-k)/(255-k);
    
    return  m * 100 / 255;
}

-(NSUInteger)yellow {

    const CGFloat* components = CGColorGetComponents(self.CGColor);
    NSUInteger R = components[0]*255;
    NSUInteger G = components[1]*255;
    NSUInteger B = components[2]*255;
    
    CGFloat k = MIN(255-R,MIN(255-G,255-B));
    CGFloat y = 255*(255-B-k)/(255-k);
    
    return  y * 100 / 255;
}

-(NSUInteger)black {
    
    const CGFloat* components = CGColorGetComponents(self.CGColor);
    NSUInteger R = components[0]*255;
    NSUInteger G = components[1]*255;
    NSUInteger B = components[2]*255;
    
    CGFloat k = MIN(255-R,MIN(255-G,255-B));
    
    return  k * 100 / 255;
}

@end

@implementation UIColor (HSB_Addition)

-(CGFloat)hue {
    HSBColor *color = [HSBColor colorWithSystemColor:self];
    return color.hue;
}

-(CGFloat)saturation {
    HSBColor *color = [HSBColor colorWithSystemColor:self];
    return color.saturation;
}

-(CGFloat)brightness {
    HSBColor *color = [HSBColor colorWithSystemColor:self];
    return color.brightness;
}

@end

@implementation UIColor (CIE_Addition)

-(CGFloat)cieX {
    CIExyzColor *color = [CIExyzColor cieXYZcolorWithSystemColor:self];
    return color.xCIE;
}

-(CGFloat)cieY {
    CIExyzColor *color = [CIExyzColor cieXYZcolorWithSystemColor:self];
    return color.yCIE;
}

-(CGFloat)cieZ {
    CIExyzColor *color = [CIExyzColor cieXYZcolorWithSystemColor:self];
    return color.zCIE;
}

-(CGFloat)cieLforWhitePoint:(UIColor*)white {
    CIELabColor *col = [CIELabColor colorWithSystemColor:self andWhiteColor:white];
    return col.lCIE;
}

-(CGFloat)cieAforWhitePoint:(UIColor*)white {
    CIELabColor *col = [CIELabColor colorWithSystemColor:self andWhiteColor:white];
    return col.aCIE;
}

-(CGFloat)cieBforWhitePoint:(UIColor*)white {
    CIELabColor *col = [CIELabColor colorWithSystemColor:self andWhiteColor:white];
    return col.bCIE;
}

-(CGFloat)cieHunterL {
    CIELabColor *col = [CIELabColor labColorWithSystemColor:self];
    return col.lCIE;
}

-(CGFloat)cieHunterA {
    CIELabColor *col = [CIELabColor labColorWithSystemColor:self];
    return col.aCIE;
}

-(CGFloat)cieHunterB {
    CIELabColor *col = [CIELabColor labColorWithSystemColor:self];
    return col.bCIE;
}

@end

@implementation UIColor (convertAddition) 

- (NSString*)formatedTextForMode:(enum ColorMode)mode imageWhitePoint:(UIColor*)whitePoint {
    
    NSString *details = nil;
    
    switch (mode) {

        case kShowCMYK: 
        {   
            NSUInteger cyan            =   self.cyan;
            NSUInteger magenta         =   self.magenta;
            NSUInteger yell            =   self.yellow;
            NSUInteger black           =   self.black;
            details = [NSString stringWithFormat:@"C:%lu%% - M:%lu%% - Y:%lu%% - K:%lu%%", (unsigned long)cyan, (unsigned long)magenta, (unsigned long)yell, (unsigned long)black];
        }
            break;
        case kShwowHsb: 
        {
            int hue             =   self.hue;
            int sat             =   self.saturation*100;
            int brig            =   self.brightness*100;
            details = [NSString stringWithFormat:@"H: %d - S: %d%% - B: %d%%",hue, sat, brig];
            break;
        }
            
        case kShowHBWLum: 
        {
            int hue             =   self.hue;
            int sat             =   self.saturation*100;
            int gLigh           =   self.grayLuminosity*100;
            details = [NSString stringWithFormat:@"H: %d - S: %d%% - L(BW): %d%%",hue, sat, gLigh];
        }
            break;
        case kShowCIExyz: 
        {
            int cieX             =   self.cieX*100;
            int cieY             =   self.cieY*100;
            int cieZ             =   self.cieZ*100;
            details = [NSString stringWithFormat:@"CIE X: %d Y: %d Z: %d",cieX, cieY, cieZ];
        }
            break;
        case kShowCIELab: 
        {
            if (whitePoint) {
                int cieL        =   [self cieLforWhitePoint:whitePoint];
                int cieA        =   [self cieAforWhitePoint:whitePoint];
                int cieB        =   [self cieBforWhitePoint:whitePoint];
                details = [NSString stringWithFormat:@"L: %d%% a: %d b: %d (not Right!)" ,cieL, cieA, cieB];
            } else {
                details = @"CIE Lab .... No white Point define ....";
            }
            
//            int cieL        =   self.cieHunterL;
//            int cieA        =   self.cieHunterA*100;
//            int cieB        =   self.cieHunterB*100;
//            details = [NSString stringWithFormat:@"L: %d%% a: %d b: %d" ,cieL, cieA, cieB];
        }
            break;
            
        case kShowRGB:   
        default:
        {
            int red             =	self.red*255.0;
            int green           =	self.green*255.0;
            int blue            =	self.blue*255.0;
            details = [NSString stringWithFormat:@"R: %d - G: %d - B: %d", red, green, blue];
        }
            break;
    }
    
    return details;
}

- (NSString*)formatedTextForMode:(enum ColorMode)mode {
    return [self formatedTextForMode:mode imageWhitePoint:nil];
}

-(CGFloat)grayLightness {
	CGFloat min, max;
	min = MIN( self.red, self.green );
	max = MAX( self.red, self.green );
    min = MIN( min, self.blue );
	max = MAX( max, self.blue );
    
    return (max + min)/2;
}

-(CGFloat)grayAverage {
    return (self.red + self.green + self.blue)/3.0;
}

-(CGFloat)grayLuminosity {
    return 0.21*self.red + 0.71*self.green + 0.07*self.blue;
}

@end
