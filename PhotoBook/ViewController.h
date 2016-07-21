//
//  ViewController.h
//  PhotoBook
//
//  Created by CQUGSR on 20/07/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIngleImageViewController.h"

NSString *const FlickrAPIKey = @"5852175cfa272c197dbddb2dd6a9243e";


@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate, UINavigationBarDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *authorIds;
    NSMutableArray *dateTaken;

    NSMutableArray *smallImageUrlArray;
    NSMutableArray *largeImageUrlArray;
    NSMutableArray *smallImageArray;

    NSInteger totalImageNo;
}

@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, retain) UILabel *headerLabel;

-(void)searchButtonClicked:(UIButton*)sender;
-(void)fetchFlickrPublicImages;

@end

