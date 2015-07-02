//
//  GPUImageAddStencilChanger.h
//  GPUImage
//
//  Created by 季震 on 6/29/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageAddPictureTextureArray.h"

@class GPUImageAddPictureTextureArray;
@interface GPUImageAddStencilChanger : NSObject
{
    
    //GPUImageAddPictureTextureArray * tt;
    
}


@property(readwrite, nonatomic, strong) GPUImageAddPictureTextureArray * tt;
@property(readwrite, nonatomic, strong) GPUImageAddPictureMoreDetail * currentPic;

- (id)init;

- (BOOL)templatePictureLoad:(NSString * )picPath with:(GPUImageOutput<GPUImageInput> *)filter;
@end
