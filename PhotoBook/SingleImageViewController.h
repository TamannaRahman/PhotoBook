//
//  SingleImageViewController.h
//  PhotoBook
//
//  Created by CQUGSR on 21/07/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface SingleImageViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    
}
@property (nonatomic) NSString *singleImageUrlData;
@property (nonatomic) NSString *imageMetaData;


-(void)saveButtonClicked:(UIButton*)sender;
-(void)sendEmailButtonClicked:(UIButton*)sender;
-(void)showEmail;
-(void)openBrowserButtonClicked:(UIButton*)sender;

@end
