//
//  UIColor+HSBColorAddition.h
//
//  Created by Denis Martin on 20/05/2011.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/** \class UIColor convertAddition
 \brief This UIColor category is an utility to retrieve some different colors value from a UIColor
 \author Created by MARTIN Denis on 5/20/11.
 \version 1.0
 */

enum ColorMode {
    kShowRGB    = 101,
    kShowCMYK   = 102,
    kShwowHsb   = 103,
    kShowHBWLum = 104,   
    
    kShowCIExyz = 105,
    kShowCIELab = 106
};


@interface UIColor (RGB_Addition)

/**
 \brief Return the RGBA as property
 
 \result red        ... 0 to 1
 \result green      ... 0 to 1
 \result blue       ... 0 to 1
 \result alpha      ... 0 to 1
 */
@property (readonly) CGFloat red;
@property (readonly) CGFloat green;
@property (readonly) CGFloat blue;
@property (readonly) CGFloat alpha;

@end


@interface UIColor (CMYK_Addition)

/**
 \brief Return the CMYK as property
 
 \result cyan        ... 0 to 100
 \result magenta     ... 0 to 100
 \result yellow      ... 0 to 100
 \result black       ... 0 to 100
 */
@property (readonly) NSUInteger cyan;
@property (readonly) NSUInteger magenta;
@property (readonly) NSUInteger yellow;
@property (readonly) NSUInteger black;

@end

@interface UIColor (HSB_Addition)

/**
 \brief Return the HSB as property
 
 \result Hue        ... 0 to 360
 \result Saturation ... 0 to 1
 \result Brightness ... 0 to 1
 */
@property (readonly) CGFloat hue;
@property (readonly) CGFloat saturation;
@property (readonly) CGFloat brightness;

@end

@interface UIColor (CIE_Addition)

/**
 \brief Return the CIE xyz as property
 
 \result x          ... 0 to 1
 \result y          ... 0 to 1
 \result z          ... 0 to 1
 */
@property (readonly) CGFloat cieX;
@property (readonly) CGFloat cieY;
@property (readonly) CGFloat cieZ;


/**
 \brief Return the CIE Lab property
 
 \result L          ... 0 to 100
 \result a          ... -xxx to +xxx
 \result b          ... -xxx to +xxx
 */
-(CGFloat)cieLforWhitePoint:(UIColor*)white;
-(CGFloat)cieAforWhitePoint:(UIColor*)white;
-(CGFloat)cieBforWhitePoint:(UIColor*)white;

/**
 \brief Return the CIE Lab property (hunter version base on D65)
 
 \result L          ... 0 to 100
 \result a          ... -xxx to +xxx
 \result b          ... -xxx to +xxx
 */
@property (readonly) CGFloat cieHunterL;
@property (readonly) CGFloat cieHunterA;
@property (readonly) CGFloat cieHunterB;


@end

@interface UIColor (convertAddition) 

/**
 \brief Return the formated text fo a given mode
 
 \param whitePoint ... The white point color to calculate the CIELab color
 \result formated string      
 */
- (NSString*)formatedTextForMode:(enum ColorMode)mode imageWhitePoint:(UIColor*)whitePoint;
- (NSString*)formatedTextForMode:(enum ColorMode)mode;

/**
 \brief Return the (Black/white)L as property
 \see http://docs.gimp.org/2.6/en/gimp-tool-desaturate.html
 
 \result grayLightness  ... 0 to 1
 \result grayAverage    ... 0 to 1
 \result grayLuminosity ... 0 to 1

 */
@property (readonly) CGFloat grayLightness;
@property (readonly) CGFloat grayAverage;
@property (readonly) CGFloat grayLuminosity;

@end


