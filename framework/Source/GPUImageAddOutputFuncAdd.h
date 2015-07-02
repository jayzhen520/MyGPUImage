//
//  GPUImageAddOutputFuncAdd.h
//  GPUImage
//
//  Created by 季震 on 6/28/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <GPUImage/GPUImage.h>

@interface GPUImageAddOutputFuncAdd : GPUImageOutput
{
    GPUImageAddPictureTextureArray * openglImageArray;
}

- (void)delTarget:(id<GPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;

@end
