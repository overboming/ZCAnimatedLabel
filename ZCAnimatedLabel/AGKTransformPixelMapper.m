//
// Author: Håvard Fossli <hfossli@agens.no>
// Author: Marcos Fuentes http://stackoverflow.com/users/1637195/marcos-fuentes
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AGKTransformPixelMapper.h"
#import <QuartzCore/QuartzCore.h>

@interface AGKTransformPixelMapper ()

@property (nonatomic, assign, readwrite) CATransform3D transform;
@property (nonatomic, assign, readwrite) CGPoint anchorPoint;
@property (nonatomic, assign, readwrite) double denominatorX;
@property (nonatomic, assign, readwrite) double denominatorY;
@property (nonatomic, assign, readwrite) double denominatorW;

@end


// Code and algorithms derives from http://stackoverflow.com/a/13850972/202451

@implementation AGKTransformPixelMapper

- (id)initWithTransform:(CATransform3D)t anchorPoint:(CGPoint)anchorPoint
{
    self = [self init];
    if(self)
    {
        
        self.denominatorX = t.m12 * t.m21 - t.m11  * t.m22 + t.m14 * t.m22 * t.m41 - t.m12 * t.m24 * t.m41 - t.m14 * t.m21 * t.m42 +
        t.m11 * t.m24 * t.m42;
        
        self.denominatorY = -t.m12 *t.m21 + t.m11 *t.m22 - t.m14 *t.m22 *t.m41 + t.m12 *t.m24 *t.m41 + t.m14 *t.m21 *t.m42 -
        t.m11* t.m24 *t.m42;
        
        self.denominatorW = t.m12 *t.m21 - t.m11 *t.m22 + t.m14 *t.m22 *t.m41 - t.m12 *t.m24 *t.m41 - t.m14 *t.m21 *t.m42 +
        t.m11 *t.m24 *t.m42;
        
        self.transform = t;
        self.anchorPoint = anchorPoint;
    }
    return self;
}

- (CGPoint)projectedPointForModelPoint:(CGPoint)point
{
    CATransform3D t = self.transform;
    double x = point.x;
    double y = point.y;
    
    double xp = (t.m22 *t.m41 - t.m21 *t.m42 - t.m22* x + t.m24 *t.m42 *x + t.m21* y - t.m24* t.m41* y) / self.denominatorX;
    double yp = (-t.m11 *t.m42 + t.m12 * (t.m41 - x) + t.m14 *t.m42 *x + t.m11 *y - t.m14 *t.m41* y) / self.denominatorY;
    double wp = (t.m12 *t.m21 - t.m11 *t.m22 + t.m14*t.m22* x - t.m12 *t.m24* x - t.m14 *t.m21* y + t.m11 *t.m24 *y) / self.denominatorW;
    
    CGPoint result = CGPointMake(xp/wp, yp/wp);
    return result;
}

- (void)mapBitmap:(in unsigned char *)input
               to:(out unsigned char *)output
           inSize:(CGSize)inSize
          outSize:(CGSize)outSize
            scale:(double)scale
    bytesPerPixel:(size_t)bytesPerPixel
      bytesPerRow:(size_t)bytesPerRow;
{
    int width = inSize.width;
    int height = inSize.height;
    
    size_t bytesInTotal = height * bytesPerRow;
    
    for (size_t y = 0 ; y < height ; ++y)
    for (size_t x = 0 ; x < width ; ++x)
    {
        size_t indexOutput = bytesPerPixel * x + bytesPerRow * y;
        
        CGPoint modelPoint = CGPointMake((x*2.0/scale - outSize.width/scale)/2.0,
                                         (y*2.0/scale - outSize.height/scale)/2.0);
        
        CGPoint p = [self projectedPointForModelPoint:modelPoint];
        p.x *= scale;
        p.y *= scale;
        
        size_t indexInput = bytesPerPixel*(size_t)p.x + (bytesPerRow*(size_t)p.y);
        BOOL isOutOfBounds = p.x >= width || p.x < 0 || p.y >= height || p.y < 0 || indexInput > bytesInTotal;
        
        if (isOutOfBounds)
        {
            for(size_t j = 0; j < bytesPerPixel; j++)
            {
                output[indexOutput+j] = 0;
            }
        }
        else
        {
            for(size_t j = 0; j < bytesPerPixel; j++)
            {
                output[indexOutput+j] = input[indexInput+j];
            }
        }
    }
}

- (CGImageRef)createMappedImageRefFrom:(CGImageRef)imageRef scale:(double)scale
{
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);

    size_t bitsPerComponent = 8;
    size_t bytesPerPixel = 4;
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    size_t bytesInTotal = height * bytesPerRow;

    unsigned char *inputData = malloc(bytesInTotal);
    unsigned char *outputData = malloc(bytesInTotal);

    // in case not every bit is drawn into outputData (this is necessary)
    for (int ii = 0 ; ii < bytesInTotal; ++ii)
    {
        outputData[ii] = 0;
        inputData[ii] = 0;
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(inputData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);

    [self mapBitmap:inputData
                 to:outputData
             inSize:CGSizeMake(width, height)
            outSize:CGSizeMake(width, height)
              scale:scale
      bytesPerPixel:bytesPerPixel
        bytesPerRow:bytesPerRow];

    CGContextRef ctx;
    ctx = CGBitmapContextCreate(outputData,
                                width,
                                height,
                                bitsPerComponent,
                                CGImageGetBytesPerRow(imageRef),
                                CGImageGetColorSpace(imageRef),
                                (CGBitmapInfo) kCGImageAlphaPremultipliedLast
                                );

    imageRef = CGBitmapContextCreateImage(ctx);

    CGContextRelease(ctx);
    free(inputData);
    free(outputData);

    return imageRef;
}

@end
