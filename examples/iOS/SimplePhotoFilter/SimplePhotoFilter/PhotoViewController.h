#import <UIKit/UIKit.h>
#import "GPUImage.h"

//typedef NS_ENUM(NSInteger, FaceConstructMode){
//    FACESTENCIL,
//    PHOTO_PLUS_STENCIL,
//};

typedef enum:NSUInteger{
    BAOZOUFACE_USE_CAMERA,
    BAOZOUFACE_USE_PHOTO
} bzFaceMode;

@interface PhotoViewController : UIViewController
{
    GPUImageStillCamera *stillCamera;
    GPUImageOutput<GPUImageInput> *filter, *secondFilter, *terminalFilter;
    UISlider *filterSettingsSlider;
    UIButton *photoCaptureButton;
    
    UISlider *picLeftRightMove;
    UISlider *picUpDownMove;
    UISlider *picScale;
    UISlider *picRotate;
    
    bzFaceMode mode;
    
    //为渲染的两张图准备的，跟显示并无关系。
    GPUImagePicture *sourcePicture;
    GPUImagePicture * sourcePicture2;
    GPUImagePicture * sourcePhotoPicture;
}

- (IBAction)updateSliderValue:(id)sender;
- (IBAction)takePhoto:(id)sender;

- (IBAction)lr:(id)sender;
- (IBAction)ud:(id)sender;
- (IBAction)s:(id)sender;
- (IBAction)r:(id)sender;

@end
