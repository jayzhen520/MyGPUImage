//
//  GPUImageAddPictureTextureArray.h
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"

@interface GPUImageAddPictureTextureArray : NSObject
{
    //@public
    //NSMutableArray * image_picture_tex;
}

@property(readwrite, nonatomic, strong) NSMutableArray *image_picture_tex;

-(BOOL)addImage:(NSString *)picturePath;
-(BOOL)delImage:(NSString *)picturePath;
-(BOOL)addImageArray:(NSArray *)pictureArrayPath;
-(GPUImageAddPictureMoreDetail *)getOpenGLImage:(NSString *)picturePath;
-(NSUInteger)findOpenGLImage:(NSString *)picturePath;

@end
