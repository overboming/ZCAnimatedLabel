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

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface AGKTransformPixelMapper : NSObject

@property (nonatomic, assign, readonly) CATransform3D transform;
@property (nonatomic, assign, readonly) double denominatorX;
@property (nonatomic, assign, readonly) double denominatorY;
@property (nonatomic, assign, readonly) double denominatorW;

- (id)initWithTransform:(CATransform3D)t anchorPoint:(CGPoint)anchorPoint;
- (CGPoint)projectedPointForModelPoint:(CGPoint)point;

- (void)mapBitmap:(in unsigned char *)input
               to:(out unsigned char *)output
           inSize:(CGSize)inSize
          outSize:(CGSize)outSize
            scale:(double)scale
    bytesPerPixel:(size_t)bytesPerPixel
      bytesPerRow:(size_t)bytesPerRow;

- (CGImageRef)createMappedImageRefFrom:(CGImageRef)imageRef scale:(double)scale CF_RETURNS_RETAINED;

@end
