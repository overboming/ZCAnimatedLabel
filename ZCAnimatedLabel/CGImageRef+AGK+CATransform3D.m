//
// Author: Håvard Fossli <hfossli@agens.no>
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


#import "CGImageRef+AGK+CATransform3D.h"
#import "AGKTransformPixelMapper.h"

// Refactored and improved upon this answer
// http://stackoverflow.com/a/13850972/202451

CGImageRef CGImageDrawWithCATransform3D_AGK(CGImageRef imageRef,
                                            CATransform3D transform,
                                            CGPoint anchorPoint,
                                            CGSize size,
                                            CGFloat scale)
{
    CATransform3D translateDueToAnchor = CATransform3DMakeTranslation(size.width * (-anchorPoint.x),
                                                                      size.height * (-anchorPoint.y),
                                                                      0);
    
    CATransform3D translateDueToDisposition = CATransform3DMakeTranslation(size.width * (-0.5 + anchorPoint.x),
                                                                           size.height * (-0.5 + anchorPoint.y),
                                                                           0);
    
    transform = CATransform3DConcat(translateDueToAnchor, transform);
    transform = CATransform3DConcat(transform, translateDueToDisposition);
    
    AGKTransformPixelMapper *mapper = [[AGKTransformPixelMapper alloc] initWithTransform:transform anchorPoint:anchorPoint];
    CGImageRef newImageRef = [mapper createMappedImageRefFrom:imageRef scale:scale];

    return newImageRef;
}