//
//  GPUImageAddPicture2Texture.h
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#else
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#endif

#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>

#import "GPUImage.h"

@class GPUImageAddPictureMoreDetail;
@interface GPUImageAddPicture2Texture : NSObject
{
    //GPUImagePicture * sourcePicture;
}
@property (readonly) GLuint textureId;


//此函数必须在OpenGL线程执行，其它线程无效。
+ (GPUImageAddPictureMoreDetail *)getOpenGLImage:(NSString *) picturePath;


@end
