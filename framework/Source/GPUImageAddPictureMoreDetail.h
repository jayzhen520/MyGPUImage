//
//  GPUImageAddPictureMoreDetail.h
//  GPUImage
//
//  Created by 季震 on 6/26/15.
//  Copyright (c) 2015 Brad Larson. All rights reserved.
//

#import <GPUImage.h>

@interface GPUImageAddPictureMoreDetail : GPUImagePicture
{
    //用于标识原来真实的图片，通过路径做比较
    
}

@property (nonatomic, strong) NSString * picturePath;
- (id)initWithImage:(UIImage *)newImageSource smoothlyScaleOutput:(BOOL)smoothlyScaleOutput withPath:(NSString *) picturePath;

- (BOOL)processImageWithCompletionHandler:(void (^)(void))completion;
@end
