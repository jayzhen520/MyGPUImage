//
//  test.m
//  GPUImage
//
//  Created by 季震 on 6/25/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

/*
 this is a test;
 this it another test;
 */

#import "GPUImageAddMiddleLayer.h"
#import "GPUImage.h"

@implementation GPUImageAddMiddleLayer

+ (void)MatrixTransFromGLKitMatrix4:(GLKMatrix4) inputMatrix ToGPUMatrix4x4:(GPUMatrix4x4 *) outputMatrix
{
    //这里的赋值考虑进行优化
    //memcpy((void *)(&outputMatrix->one), &inputMatrix.m[0], sizeof(outputMatrix->one));
    
    
    outputMatrix->one.one = inputMatrix.m[0];
    outputMatrix->one.two = inputMatrix.m[1];
    outputMatrix->one.three = inputMatrix.m[2];
    outputMatrix->one.four = inputMatrix.m[3];
    
    outputMatrix->two.one = inputMatrix.m[4];
    outputMatrix->two.two = inputMatrix.m[5];
    outputMatrix->two.three = inputMatrix.m[6];
    outputMatrix->two.four = inputMatrix.m[7];
    
    outputMatrix->three.one = inputMatrix.m[8];
    outputMatrix->three.two = inputMatrix.m[9];
    outputMatrix->three.three = inputMatrix.m[10];
    outputMatrix->three.four = inputMatrix.m[11];
    
    outputMatrix->four.one = inputMatrix.m[12];
    outputMatrix->four.two = inputMatrix.m[13];
    outputMatrix->four.three = inputMatrix.m[14];
    outputMatrix->four.four = inputMatrix.m[15];
    //outputMatrix = (GPUMatrix4x4)outputMatrix;
    //outputMatrix
}

@end
