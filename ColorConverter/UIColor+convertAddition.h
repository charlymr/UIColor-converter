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

@interface UIColor (convertAddition) 

/**
 \brief Return the formated text fo a given mode
 
 \param whitePoint ... The white point color to calculate the CIELab color
 \result formated string      
 */
- (NSString*)formatedTextForMode:(enum ColorMode)mode imageWhitePoint:(UIColor*)whitePoint;
- (NSString*)formatedTextForMode:(enum ColorMode)mode;


/**
 \brief Return the HSB as property
 
 \result Hue        ... 0 to 360
 \result Saturation ... 0 to 1
 \result Brightness ... 0 to 1
*/
@property (readonly) float hue;
@property (readonly) float saturation;
@property (readonly) float brightness;

/**
 \brief Return the (Black/white)L as property
 \see http://docs.gimp.org/2.6/en/gimp-tool-desaturate.html
 
 \result grayLightness  ... 0 to 1
 \result grayAverage    ... 0 to 1
 \result grayLuminosity ... 0 to 1

 */
@property (readonly) float grayLightness;
@property (readonly) float grayAverage;
@property (readonly) float grayLuminosity;

/**
 \brief Return the RGBA as property
 
 \result red        ... 0 to 1
 \result green      ... 0 to 1
 \result blue       ... 0 to 1
 \result alpha      ... 0 to 1
 */
@property (readonly) float red;
@property (readonly) float green;
@property (readonly) float blue;
@property (readonly) float alpha;

/**
 \brief Return the CMYK as property
 
 \result cyan        ... 0 to 100
 \result magenta     ... 0 to 100
 \result yellow      ... 0 to 100
 \result black       ... 0 to 100
 */
@property (readonly) int cyan;
@property (readonly) int magenta;
@property (readonly) int yellow;
@property (readonly) int black;

/**
 \brief Return the CIE xyz as property
 
 \result x          ... 0 to 1
 \result y          ... 0 to 1
 \result z          ... 0 to 1
 */
@property (readonly) float cieX;
@property (readonly) float cieY;
@property (readonly) float cieZ;

/**
 \brief Return the CIE Lab property 
 .... It is buggy and the value don't seems right!!!
 
 \result L          ... 0 to 100
 \result a          ... -xxx to +xxx
 \result b          ... -xxx to +xxx
 */
-(float)cieLforWhitePoint:(UIColor*)white;
-(float)cieAforWhitePoint:(UIColor*)white;
-(float)cieBforWhitePoint:(UIColor*)white;

/**
 \brief Return the CIE Lab property (hunter version base on D65)
 .... It is buggy and the value don't seems right!!!

 \result L          ... 0 to 100
 \result a          ... -xxx to +xxx
 \result b          ... -xxx to +xxx
 */
@property (readonly) float cieHunterL;
@property (readonly) float cieHunterA;
@property (readonly) float cieHunterB;

@end


