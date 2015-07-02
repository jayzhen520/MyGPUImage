//
//  GPUImageAddPicture2Texture.m
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import "GPUImageAddPicture2Texture.h"

@implementation GPUImageAddPicture2Texture

+ (GPUImageAddPictureMoreDetail * )getOpenGLImage:(NSString *) picturePath{
    UIImage *inputImage;
    inputImage = [UIImage imageNamed:picturePath];
    
    GPUImageAddPictureMoreDetail * sourcePicture = [[GPUImageAddPictureMoreDetail alloc] initWithImage:inputImage smoothlyScaleOutput:YES withPath:picturePath];
    
    return sourcePicture;
}

@end
