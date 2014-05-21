//
//  CropImageViewController.h
//  BarMates
//
//  Created by George on 08/01/14.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol CropImageDelegate

-(void)cropImage:(UIImage*)img;

@end

@interface CropImageViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *pictureView;

@property (assign, nonatomic) id<CropImageDelegate> delegate;
@property (assign, nonatomic) int slot;
@property (strong, nonatomic) NSString *string;
@property (strong, nonatomic) UIImage *img;
@property (retain, nonatomic) IBOutlet UIImageView *uncroppedImage;
@property (retain, nonatomic) IBOutlet UIButton *chooseButton;
@property (retain, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *crop;
@property (weak, nonatomic) IBOutlet UIButton *cancel;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;


@end
