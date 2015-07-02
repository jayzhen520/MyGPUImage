//
//  GPUImageAddStencilChanger.m
//  GPUImage
//
//  Created by 季震 on 6/29/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import "GPUImageAddStencilChanger.h"

@implementation GPUImageAddStencilChanger

- (id) init
{
    self.tt = [[GPUImageAddPictureTextureArray alloc] init];
    return self;
}

- (BOOL)templatePictureLoad:(NSString * )picPath with:(GPUImageOutput<GPUImageInput> *)filter;
{
    GPUImageAddPictureMoreDetail * pic;
    if([self.tt findOpenGLImage:picPath] == -1){
        [self.tt addImage:picPath];
        pic = [self.tt getOpenGLImage:picPath];
        
        //删除当前的渲染图片
        GPUImageAddPictureMoreDetail * oldPic = self.currentPic;
        if(oldPic != nil){
            [oldPic removeTarget:filter];
        }
        
        [pic processImage];
        [self setCurrentPic:pic];
        [pic addTarget:filter];
    }else{
        pic = [self.tt getOpenGLImage:picPath];
        GPUImageAddPictureMoreDetail * oldPic = self.currentPic;
        if(oldPic != nil){
            [oldPic removeTarget:filter];
        }
        [self setCurrentPic:pic];
        [pic addTarget:filter];
    }
    return true;
}

@end
