//
//  CropImageViewController.m
//  BarMates
//
//  Created by George on 08/01/14.
//
//

#import "CropImageViewController.h"

@interface CropImageViewController ()

@end

@implementation CropImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        self.uncroppedImage.transform = CGAffineTransformScale([self.uncroppedImage transform], [gestureRecognizer scale], [gestureRecognizer scale]);
        [gestureRecognizer setScale:1];
        //		changeableImage.frame = gestureRecognizer
    }
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *piece = self.uncroppedImage;
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
}

- (IBAction)cancelCrop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cropEnded:(id)sender {
    
    
    [self.pictureView.layer setBorderWidth:0.0];
    
    UIGraphicsBeginImageContextWithOptions(self.pictureView.frame.size, NO, 0.0);
    [self.pictureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.img = screenShot;
    [self dismissViewControllerAnimated:YES completion:^{[self animationCompleted];}];
}

-(void)animationCompleted{
    
    // Whatever you want to do after finish animation
    [self.delegate cropImage:self.img];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.uncroppedImage.image = self.img;
    UIGestureRecognizer *recognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
	[self.view addGestureRecognizer:recognizer];
	
	UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
    
    [self.pictureView.layer setMasksToBounds:YES];
    [self.pictureView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.pictureView.layer setBorderWidth:2.0];
    
    [self.cancel.layer setMasksToBounds:YES];
	[self.cancel.layer setCornerRadius:5.0];
    self.cancel.backgroundColor = commonColor;
    
    [self.crop.layer setMasksToBounds:YES];
	[self.crop.layer setCornerRadius:5.0];
    self.crop.backgroundColor = commonColor;
    
    if (!IS_IPHONE_5){
        self.pictureView.frame = CGRectMake(self.pictureView.frame.origin.x, self.pictureView.frame.origin.y, self.pictureView.frame.size.width, self.pictureView.frame.size.height-88);
        self.chooseButton.frame = CGRectMake(self.chooseButton.frame.origin.x, self.chooseButton.frame.origin.y-88, self.chooseButton.frame.size.width, self.chooseButton.frame.size.height);
        self.cancelButton.frame = CGRectMake(self.cancelButton.frame.origin.x, self.cancelButton.frame.origin.y-88, self.cancelButton.frame.size.width, self.cancelButton.frame.size.height);
        
    }
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSFontAttributeName,nil];
    
    self.navBar.titleTextAttributes = textAttributes;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
