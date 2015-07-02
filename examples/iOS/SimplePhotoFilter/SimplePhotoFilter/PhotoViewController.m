#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //openglImageArray = [[GPUImageAddPictureTextureArray alloc] init];
    stencilChanger = [[GPUImageAddStencilChanger alloc] init];
    
    loopTest = 0;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView 
{
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	    
    // Yes, I know I'm a caveman for doing all this by hand
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
	filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    filterSettingsSlider.minimumValue = 0.0;
    filterSettingsSlider.maximumValue = 3.0;
    filterSettingsSlider.value = 0.5;
    
    [primaryView addSubview:filterSettingsSlider];
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoCaptureButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 90.0, 150.0, 40.0);
    [photoCaptureButton setTitle:@"Capture Photo" forState:UIControlStateNormal];
	photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    [primaryView addSubview:photoCaptureButton];
    
    stencilChangeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stencilChangeButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 190.0, 150.0, 40.0);
    [stencilChangeButton setTitle:@"StencilChange" forState:UIControlStateNormal];
    stencilChangeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [stencilChangeButton addTarget:self action:@selector(changeStencil:) forControlEvents:UIControlEventTouchUpInside];
    [stencilChangeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [primaryView addSubview:stencilChangeButton];

    
	self.view = primaryView;	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stillCamera = [[GPUImageStillCamera alloc] init];
//    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    filter = [[GPUImageGammaFilter alloc] init];
    filter = [[GPUImageSaturationBlendFilter alloc] init];
//    filter = [[GPUImageUnsharpMaskFilter alloc] init];
//    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
//    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
//    filter = [[GPUImageSmoothToonFilter alloc] init];
//    filter = [[GPUImageSepiaFilter alloc] init];
//    filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.5, 0.5, 0.5, 0.5)];
//    secondFilter = [[GPUImageSepiaFilter alloc] init];
//    terminalFilter = [[GPUImageSepiaFilter alloc] init];
//    [filter addTarget:secondFilter];
//    [secondFilter addTarget:terminalFilter];
    
//	[filter prepareForImageCapture];
//	[terminalFilter prepareForImageCapture];
    
    [stillCamera addTarget:filter];
    
    GPUImageView *filterView = (GPUImageView *)self.view;
    //    [filter addTarget:filterView];
    [filter addTarget:filterView];
    //    [terminalFilter addTarget:filterView];
    
    //    [stillCamera.inputCamera lockForConfiguration:nil];
    //    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
    //    [stillCamera.inputCamera unlockForConfiguration];
    
    [stillCamera startCameraCapture];
    
    //UIImage *inputImage = [UIImage imageNamed:@"panda_4_3_king_hole.png"];
    //memoryPressurePicture1 = [[GPUImagePicture alloc] initWithImage:inputImage];
    //
    //memoryPressurePicture2 = [[GPUImagePicture alloc] initWithImage:inputImage];
    
//    UIImage * inputImage2;
//    inputImage2 = [UIImage imageNamed:@"pic/pandas2/表情600.jpg"];
//    sourcePicture2 = [[GPUImagePicture alloc] initWithImage:inputImage2 smoothlyScaleOutput:YES];
//    [sourcePicture2 processImage];
//    [sourcePicture2 addTarget:filter];
//    
//    
//    
//    UIImage *inputImage;
//    inputImage = [UIImage imageNamed:@"pic/pandas/表情600_hole.png"];
//    
//    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
//    [sourcePicture processImage];
//    [sourcePicture addTarget:filter];
    
    
//    [openglImageArray addImage:@"pic/pandas2/表情600.jpg"];
//    GPUImageAddPictureMoreDetail * pic;
//    pic = [self->openglImageArray getOpenGLImage:@"pic/pandas2/表情600.jpg"];
//    [pic processImage];
//    [pic addTarget:filter];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateSliderValue:(id)sender
{
//    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
//    [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]];
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    [baozoubiaoqingfilter setFactor:[(UISlider *)sender value]];
    
    /*
     *下面的函数调用应当是通过两指触控调用的函数，暂且添加在此处。
     */
    //做平移变换，值为0.0时为平移0。
    [baozoubiaoqingfilter translateX: 0.0 Y:0.0 Z:0.0];
    //做缩放变换，值为1.0时，放大为原来的1.0倍。
    [baozoubiaoqingfilter scaleX:1.0 Y:1.0 Z:1.0];
    //
    [baozoubiaoqingfilter rotateX:0.0 Y:0.0 Z:1.0 radians:3.14159/2.0];
    
    [baozoubiaoqingfilter setMvp];
    
//    GPUImageAddPictureMoreDetail * pic;
//    
//    if(!(loopTest % 2)){
//    //if(loopTest % 2){
//        /*不存在此图：加载此图，设定使用此图为渲染图*/
//        if([openglImageArray findOpenGLImage:@"pic/pandas2/表情600.jpg"] == -1){
//            [openglImageArray addImage:@"pic/pandas2/表情600.jpg"];
//            pic = [self->openglImageArray getOpenGLImage:@"pic/pandas2/表情600.jpg"];
//            
//            //删除当前的渲染图片
//            GPUImageAddPictureMoreDetail * oldPic = openglImageArray.currentPic;
//            if(oldPic != nil){
//                [oldPic removeTarget:filter];
//            }
//            
//            [pic processImage];
//            [openglImageArray setCurrentPic:pic];
//            [pic addTarget:filter];
//        }else{
//            pic = [self->openglImageArray getOpenGLImage:@"pic/pandas2/表情600.jpg"];
//            GPUImageAddPictureMoreDetail * oldPic = openglImageArray.currentPic;
//            if(oldPic != nil){
//                [oldPic removeTarget:filter];
//            }
//            [openglImageArray setCurrentPic:pic];
//            [pic addTarget:filter];
//        }
//        
//        
//        
//    }else{
//        /*不存在此图：加载此图，设定使用此图为渲染图*/
//        if([openglImageArray findOpenGLImage:@"pic/qdmd.png"] == -1){
//            [openglImageArray addImage:@"pic/qdmd.png"];
//            pic = [self->openglImageArray getOpenGLImage:@"pic/qdmd.png"];
//            
//            //删除当前的渲染图片
//            GPUImageAddPictureMoreDetail * oldPic = openglImageArray.currentPic;
//            if(oldPic != nil){
//                [oldPic removeTarget:filter];
//            }
//            
//            [pic processImage];
//            [openglImageArray setCurrentPic:pic];
//            [pic addTarget:filter];
//        }else{
//            pic = [self->openglImageArray getOpenGLImage:@"pic/qdmd.png"];
//            GPUImageAddPictureMoreDetail * oldPic = openglImageArray.currentPic;
//            if(oldPic != nil){
//                [oldPic removeTarget:filter];
//            }
//            [openglImageArray setCurrentPic:pic];
//            [pic addTarget:filter];
//        }
//
//        
//    }
    
//    else if(loopTest % 2 == 0){
//        [openglImageArray addImage:@"pic/pandas2/表情600_hole.jpg"];
//        pic = [self->openglImageArray getOpenGLImage:@"pic/pandas2/表情600_hole.jpg"];
//        [pic processImage];
//        [pic addTarget:filter];
//    }
    loopTest++;
    
}

- (IBAction)changeStencil:(id)sender
{
    if(loopTest % 2 == 0){
//        [self templatePictureLoad:@"pic/pandas/表情600_hole.png"];
        [stencilChanger templatePictureLoad:@"pic/pandas/表情400" with:filter];
    }else{
        [stencilChanger templatePictureLoad:@"pic/qdmd.png" with:filter];
    }
    loopTest++;
}

- (IBAction)takePhoto:(id)sender;
{
    //[photoCaptureButton setEnabled:NO];
    
    /*[stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){

        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
			 
             runOnMainQueueWithoutDeadlocking(^{
                 [photoCaptureButton setEnabled:YES];
             });
         }];
    }];*/
    
    
//    NSString * pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test2.png"];
//    
//    [UIImagePNGRepresentation(processedImage) writeToFile:pngPath atomically:YES];
//    
//    NSError * myError;
//    NSFileManager * fileMgr = [NSFileManager defaultManager];
//    NSString * documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&myError]);
    
    [stillCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
         /*NSString * pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        
        [UIImagePNGRepresentation(processedImage) writeToFile:pngPath atomically:YES];
        
        NSError * myError;
        NSFileManager * fileMgr = [NSFileManager defaultManager];
        NSString * documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&myError]);*/
        
        
        if (error) {
            NSLog(@"ERROR: could not capture = %@", error);
        } else {
            NSLog(@"PHOTO SAVED - ??");
            
            // save photo to album
            UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
        }
        
        
    }];
    
    
    
    
    
}


@end































