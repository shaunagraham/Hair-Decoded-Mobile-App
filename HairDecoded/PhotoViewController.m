//
//  PhotoViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}

-(void)cropImage:(UIImage *)img{
    ////NSLog(@"%f %f",img.size.height,img.size.width);
    
    self.selectedImage.image = img;
}


- (IBAction)addPhoto:(id)sender {
    [self.description resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
    action.tag = 1;
    action.actionSheetStyle = UIActionSheetStyleDefault;
    [action showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)Upload:(id)sender {
    
    if ([self.descriptionText isEqualToString:@""]){
        ShowMessageBox(@"Please add a description.", @"", -1, nil);
        return;
    }

    if ([self.selectedImage.image isEqual:nil]){
        ShowMessageBox(@"Please select image", @"", -1, nil);
        return;
    }

    
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(uploadRequest:) withObject:nil];
    
}
- (IBAction)selectedHair:(id)sender {
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    
    self.hairTypeSelected = [segment selectedSegmentIndex];
    ////NSLog(@"%d",self.hairTypeSelected);
}




- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.defaultLabel.hidden = YES;
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0, -122, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
                       
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.defaultLabel.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{


}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    NSInteger insertDelta = text.length - range.length;
    
    if (textView.text.length + insertDelta > 80)
    {
        return NO; // return NO to not change text
    }
    else
    {
        
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }
    }
        
    
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1){
        //photo
        
        if (buttonIndex == 0){
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        else if (buttonIndex == 1){
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
        }
        
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    ////NSLog(@"%@",info);
    if ([[info objectForKey:@"UIImagePickerControllerMediaType"] isEqual:@"public.image"])
    {
       // self.croppedImage = [self fixOrientation:[info objectForKey:UIImagePickerControllerEditedImage]];
        self.croppedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        
        
        [self.imagePickerController dismissViewControllerAnimated:YES completion:^{[self animationCompleted];}];
        
     
    }
}

-(void)animationCompleted{
//    CropImageViewController *crop = [[CropImageViewController alloc]init];
//    crop.img = self.croppedImage;
//    crop.delegate = self;
//    [self presentViewController:crop animated:YES completion:nil];
    
    self.editorController = [[AFPhotoEditorController alloc] initWithImage:self.croppedImage];
    [self.editorController setDelegate:self];
    [self presentViewController:self.editorController animated:YES completion:nil];
    
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    
    
    
    ////NSLog(@"imgsize %.f",image.size.height);
    
    [self.editorController dismissViewControllerAnimated:YES completion:nil];
    self.selectedImage.image = image;
    NSLog(@"done");
}



- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancellation here
    [self.editorController dismissViewControllerAnimated:YES completion:nil];

    ////NSLog(@"cancel");
}


-(void)done{
    [self.description resignFirstResponder];
    self.defaultLabel.hidden = ([self.description.text length] > 0);
    self.descriptionText = self.description.text;
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

}

-(void)cancelButton{
    [self.description resignFirstResponder];
    self.description.text = @"";
    self.defaultLabel.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.croppedImage = nil;
    
    if (!IS_IPHONE_5){
        ////NSLog(@"1234");
        self.contentPhoto.frame = CGRectMake(self.contentPhoto.frame.origin.x, self.contentPhoto.frame.origin.y, self.contentPhoto.frame.size.width, self.contentPhoto.frame.size.height-88);
        
        self.addPhotoLabel.frame = CGRectMake(self.addPhotoLabel.frame.origin.x, self.addPhotoLabel.frame.origin.y-88, self.addPhotoLabel.frame.size.width, self.addPhotoLabel.frame.size.height);
        self.description.frame = CGRectMake(self.description.frame.origin.x, self.description.frame.origin.y-88, self.description.frame.size.width, self.description.frame.size.height);
        self.defaultLabel.frame = CGRectMake(self.defaultLabel.frame.origin.x, self.defaultLabel.frame.origin.y-88, self.defaultLabel.frame.size.width, self.defaultLabel.frame.size.height);
        self.selectedHair.frame = CGRectMake(self.selectedHair.frame.origin.x, self.selectedHair.frame.origin.y-88, self.selectedHair.frame.size.width, self.selectedHair.frame.size.height);        
        self.UploadButton.frame = CGRectMake(self.UploadButton.frame.origin.x, self.UploadButton.frame.origin.y-88, self.UploadButton.frame.size.width, self.UploadButton.frame.size.height);
        
    }
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *privacy = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButton)];
    UIBarButtonItem *barFlexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancel,barFlexible,privacy, nil]];
    self.description.inputAccessoryView = toolbar;


    [[UIBarButtonItem appearance] setTintColor:commonColor];
    
    
    [self.description.layer setMasksToBounds:YES];
	[self.description.layer setCornerRadius:5.0];
    [self.description.layer setBorderWidth:1.0];
    [self.description.layer setBorderColor:commonColor.CGColor];
    self.descriptionText = @"";
    self.hairTypeSelected = 1;
    
    [self.UploadButton.layer setMasksToBounds:YES];
	[self.UploadButton.layer setCornerRadius:5.0];
    self.UploadButton.backgroundColor = commonColor;

    
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.allowsEditing = YES;
    self.imagePickerController.delegate = self;

}


#pragma Create User
-(void)uploadRequest:(id)sender{
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@",UploadFile];
        
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        
        
        NSString *mpfBoundry = @"-----------------------------7d91191f100ca";
        [request setValue:[NSString stringWithFormat:@"multipart/form-data, boundary=%@",mpfBoundry] forHTTPHeaderField:@"Content-Type"];
        NSMutableData *postbody = [NSMutableData data];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"hair_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *hairtype = @"";
        if (self.hairTypeSelected == 0)hairtype = @"straight";
        if (self.hairTypeSelected == 1)hairtype = @"wavy";
        if (self.hairTypeSelected == 2)hairtype = @"curly";
        if (self.hairTypeSelected == 3)hairtype = @"kinky";
        
        NSLog(@"%@",hairtype);
        
        [postbody appendData:[[NSString stringWithString:hairtype] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithString:self.descriptionText] dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [postbody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"uploadedimage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //NSLog(@"%f %f",self.selectedImage.image.size.width,self.selectedImage.image.size.height);
        [postbody appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.selectedImage.image, 1.0)]];
        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        [request setHTTPBody:postbody];
        
      //  NSString *strData = [[NSString alloc]initWithData:postbody encoding:NSUTF8StringEncoding];
        ////NSLog(@"str %@",strData);
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        
        
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){

            
            [self performSelectorOnMainThread:@selector(uploadSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(uploadError:) withObject:nil waitUntilDone:YES];
            
        }
        
        
    }
}

-(void)uploadSuccess:(id)sender{
    
    
    
    [pService OnEndRequest];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Congrats! Your photo is live! Add More?" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
    alert.tag = 32;
    [alert show];
    
    self.selectedImage.image = [UIImage imageNamed:@"img.png"];
    self.description.text = @"";
    self.descriptionText = @"";
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 32){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil userInfo:nil];
        if (buttonIndex == 1)[self.tabBarController setSelectedIndex:0];
    }
}

-(void)uploadError:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Error", @"Something went wrong. Please try again", -1, nil);
    
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 11){
        self.selectedImage.image = [UIImage imageNamed:@"img.png"];
        self.description.text = @"";
        [self.tabBarController setSelectedIndex:0];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
