//
//  GPUImageAddPictureTextureArray.m
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import "GPUImageAddPictureTextureArray.h"
#import "GPUImageAddPictureMoreDetail.h"
@implementation GPUImageAddPictureTextureArray

-(id) init
{
    self.image_picture_tex = [NSMutableArray arrayWithCapacity:2];
    return self;
}

-(BOOL)addImage:(NSString *)picturePath
{
    NSUInteger index;
    index = [self findOpenGLImage:picturePath];
    
    if(index != -1){
        //已经存在此图片，不做操作
        return true;
    }
    
    GPUImageAddPictureMoreDetail * pic = [GPUImageAddPicture2Texture getOpenGLImage:picturePath];
    [_image_picture_tex addObject:pic];
    return true;
}
-(BOOL)delImage:(NSString *)picturePath{
    NSUInteger index;
    index = [self findOpenGLImage:picturePath];
    if(index != -1){
        //根本不存在，不做操作
    }
    
    /*
    是否要对OpenGL纹理进行释放
     */
    
    [self.image_picture_tex removeObjectAtIndex:index];
    
    return true;
}
-(BOOL)addImageArray:(NSArray *)pictureArrayPath{
    for(NSString * path in self.image_picture_tex){
        if([self addImage:path] == NO){
            NSLog(@"Error AddImage | From Path %@.", pictureArrayPath);
        }
    }
    return true;
}
-(GPUImageAddPictureMoreDetail *)getOpenGLImage:(NSString *)picturePath{
    NSUInteger index;
    index = [self findOpenGLImage:picturePath];
    if (index != -1) {
        return [self.image_picture_tex objectAtIndex:index];
    }else{
        return nil;
    }
}
-(NSUInteger)findOpenGLImage:(NSString *)picturePath{
    NSUInteger objCount = [self.image_picture_tex count];
    for(NSUInteger i = 0; i < objCount; i++){
        NSString * path = ((GPUImageAddPictureMoreDetail *)(self.image_picture_tex[i])).picturePath;
        if([path isEqualToString:picturePath]){
            return i;
        }
    }
    return -1;
}

@end
