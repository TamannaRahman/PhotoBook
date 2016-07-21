//
//  ViewController.h
//  PhotoBook
//
//  Created by CQUGSR on 20/07/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import <UIKit/UIKit.h>

NSString *const FlickrAPIKey = @"5852175cfa272c197dbddb2dd6a9243e";


@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *authorIds;
    NSMutableArray *dateTaken;

    NSMutableArray *smallImageUrls;
    NSMutableArray *largeImageUrls;
}

@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UILabel *headerLabel;

-(void)searchButtonClicked:(UIButton*)sender;
-(void)fetchFlickrPublicImages;

@end

