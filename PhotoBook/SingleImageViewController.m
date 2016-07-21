//
//  SIngleImageViewController.m
//  PhotoBook
//
//  Created by CQUGSR on 21/07/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import "SingleImageViewController.h"

@interface SingleImageViewController ()
{
    UIImage *largeImage;
}

@end

@implementation SingleImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor darkGrayColor];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth - 350)/2, 100, 350, 250)];
    
    largeImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_singleImageUrlData]]];
    imageview.image = largeImage;
    [self.view addSubview:imageview];
    
    UILabel *imageMetaDataLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 350)/2, 380, 350, 200)];
    //imageMetaDataLabel.backgroundColor = [UIColor greenColor];
    imageMetaDataLabel.textColor = [UIColor whiteColor];
    imageMetaDataLabel.text = _imageMetaData;
    imageMetaDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
    imageMetaDataLabel.numberOfLines = 0;
    imageMetaDataLabel.adjustsFontSizeToFitWidth = YES;
    NSLog(@"%@",_imageMetaData);
    imageMetaDataLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:20];
    [self.view addSubview:imageMetaDataLabel];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(20, screenHeight-100, 80, 80);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    UIButton *sendEmail = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sendEmail.frame = CGRectMake((screenWidth-80)/2, screenHeight-100, 80, 80);
    [sendEmail setBackgroundImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
    [sendEmail addTarget:self action:@selector(sendEmailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendEmail];
    
    UIButton *openBrowser = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    openBrowser.frame = CGRectMake(screenWidth-100, screenHeight-100, 80, 80);
    [openBrowser setBackgroundImage:[UIImage imageNamed:@"browser"] forState:UIControlStateNormal];
    [openBrowser addTarget:self action:@selector(openBrowserButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openBrowser];

}



-(void)saveButtonClicked:(UIButton*)sender
{
   UIImageWriteToSavedPhotosAlbum(largeImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)sendEmailButtonClicked:(UIButton*)sender
{
    [self showEmail];
}

-(void)openBrowserButtonClicked:(UIButton*)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_singleImageUrlData]];
}


- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    if (!error)
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Success"
                                     message:@"The picture saved successfully to your Camera Roll"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)showEmail
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Hello there"];
        [mail setMessageBody:@"Hey, Check out this image!" isHTML:NO];
        [mail setToRecipients:@[@""]];
        
        NSData *myData = UIImagePNGRepresentation(largeImage);
        [mail addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"Image.jpg"];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        NSLog(@"This device cannot send email");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
