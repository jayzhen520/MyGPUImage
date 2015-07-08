#import <Foundation/Foundation.h>
#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
    
    ////////////////////////////////////////////
    
//    - (IBAction)updateSliderValue:(id)sender
    CGRect rectlr = {25.0, mainScreenFrame.size.height - 100.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * slr = [self addSlider:picLeftRightMove inPosition:&rectlr withmaxis:1.0f minis:-1.0f originis:0.0 useFuncClass:@selector(lr:)];
    [primaryView addSubview:slr];
    
    CGRect rectud = {25.0, mainScreenFrame.size.height - 150.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * sud = [self addSlider:picUpDownMove inPosition:&rectud withmaxis:1.0f minis:-1.0f originis:0.0 useFuncClass:@selector(ud:)];
    [primaryView addSubview:sud];
    
    CGRect rects = {25.0, mainScreenFrame.size.height - 200.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * ss = [self addSlider:picScale inPosition:&rects withmaxis:1.0f minis:-1.0f originis:1.0 useFuncClass:@selector(s:)];
    [primaryView addSubview:ss];
    
    CGRect rectr = {25.0, mainScreenFrame.size.height - 250.0, mainScreenFrame.size.width - 50.0, 40.0};
    UISlider * sr = [self addSlider:picRotate inPosition:&rectr withmaxis:10.0f minis:-10.0f originis:1.0 useFuncClass:@selector(r:)];
    [primaryView addSubview:sr];
    
    ////////////////////////////////////////////
    
    
	self.view = primaryView;	
}

- (UISlider *)addSlider:(UISlider *)slider inPosition:(CGRect *)rect withmaxis:(float)max minis:(float)min originis:(float)origin useFuncClass:(SEL)ufc;
{
    /*add sliter to control photo*/
    slider = [[UISlider alloc] initWithFrame:*rect];
    [slider addTarget:self action:ufc forControlEvents:UIControlEventValueChanged];
    slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = origin;
    return slider;
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
    
    UIImage * inputImage2;
    inputImage2 = [UIImage imageNamed:@"pic/pandas2/表情600.jpg"];
    sourcePicture2 = [[GPUImagePicture alloc] initWithImage:inputImage2 smoothlyScaleOutput:YES];
    [sourcePicture2 processImage];
    [sourcePicture2 addTarget:filter];
    
    
    
    UIImage *inputImage;
    inputImage = [UIImage imageNamed:@"pic/pandas/表情600_hole.png"];
    
    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
    [sourcePicture processImage];
    [sourcePicture addTarget:filter];
    
    
    
    
    
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
    
//    /*
//     *下面的函数调用应当是通过两指触控调用的函数，暂且添加在此处。
//     */
//    //做平移变换，值为0.0时为平移0。
//    [baozoubiaoqingfilter translateX: 0.0 Y:0.0 Z:0.0];
//    //做缩放变换，值为1.0时，放大为原来的1.0倍。
//    [baozoubiaoqingfilter scaleX:1.0 Y:1.0 Z:1.0];
//    //
//    [baozoubiaoqingfilter rotateX:0.0 Y:0.0 Z:1.0 radians:3.14159/2.0];
//    
//    [baozoubiaoqingfilter setMvp];
    
}

- (IBAction)lr:(id)sender
{
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    
    float xvalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter translateX:xvalue Y:0.0 Z:0.0];
    
    [baozoubiaoqingfilter updateMvp];

}

- (IBAction)ud:(id)sender
{
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    float yvalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter translateX:0.0 Y:yvalue Z:0.0];

    [baozoubiaoqingfilter updateMvp];

}

- (IBAction)s:(id)sender{
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    
    float svalue = [(UISlider *)sender value];
    [baozoubiaoqingfilter scaleX:svalue Y:svalue Z:1.0];

    [baozoubiaoqingfilter updateMvp];

}

-(IBAction)r:(id)sender{
    
    GPUImageSaturationBlendFilter * baozoubiaoqingfilter = (GPUImageSaturationBlendFilter *)filter;
    //默认为沿着z轴做旋转
    float rvalue = [(UISlider *)sender value];
    
    [baozoubiaoqingfilter rotateX:0.0 Y:0.0 Z:1.0 radians:rvalue];
    
    [baozoubiaoqingfilter updateMvp];

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































