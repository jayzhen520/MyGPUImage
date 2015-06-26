//
//  test.h
//  GPUImage
//
//  Created by 季震 on 6/25/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImageFilter.h"
#import <GLKit/GLKit.h>

@interface GPUImageAddMiddleLayer : NSObject
{
    
}

+ (void)MatrixTransFromGLKitMatrix4:(GLKMatrix4) inputMatrix ToGPUMatrix4x4:(GPUMatrix4x4 *) outputMatrix;

@end
