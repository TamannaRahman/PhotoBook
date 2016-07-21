//
//  ViewController.m
//  PhotoBook
//
//  Created by CQUGSR on 20/07/2016.
//  Copyright © 2016 Tamanna. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navigationItem.title = @"PHOTO BOOK";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont fontWithName:@"Georgia-Bold" size:18]}];
    
    authorIds = [[NSMutableArray alloc] init];
    dateTaken = [[NSMutableArray alloc] init];
    smallImageUrlArray = [[NSMutableArray alloc] init];
    largeImageUrlArray = [[NSMutableArray alloc] init];
    smallImageArray = [[NSMutableArray alloc] init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(110, 20, 20, 20);
   
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_collectionView];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 50, 320, 50)];
    searchBar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:searchBar];
    searchBar.delegate = self;
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sortButton.frame = CGRectMake(searchBar.frame.size.width, 45, 60, 60);
    [sortButton setBackgroundImage:[UIImage imageNamed:@"sort_button"] forState:UIControlStateNormal];
    [sortButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortButton];

    [self fetchFlickrPublicImages];
    [self.collectionView reloadData];
}

-(void)sortButtonClicked:(UIButton*)sender
{
    
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void)searchButtonClicked:(UIButton*)sender
{
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return totalImageNo;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UIImage *image = [UIImage imageWithData:
                      [NSData dataWithContentsOfURL:
                       [NSURL URLWithString:
                        [smallImageUrlArray objectAtIndex:indexPath.row]]]];
    
    imageView.image = image;
    cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *getLargeImageUrl = [largeImageUrlArray objectAtIndex:indexPath.row];
    
    SingleImageViewController *singleView = [[SingleImageViewController alloc] init];
    singleView.singleImageUrlData = getLargeImageUrl;
    singleView.imageMetaData = [NSString stringWithFormat:@"Author Id: %@ \nImage Captured On: %@",
                                [authorIds objectAtIndex:indexPath.row],
                                [dateTaken objectAtIndex:indexPath.row],nil];
    NSLog(@"%@",[dateTaken objectAtIndex:indexPath.row]);
    [self.navigationController pushViewController:singleView animated:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}

-(void)fetchFlickrPublicImages
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=data"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *badJSON = [NSData dataWithContentsOfURL:url];
    
    NSString *dataAsString = [NSString stringWithUTF8String:[badJSON bytes]];
    
    NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:kNilOptions error:&error];

    NSArray *images = [json objectForKey:@"items"];
    
    for (NSDictionary *image in images)
    {
        
        NSString *authorId = [image objectForKey:@"author_id"];
        [authorIds addObject:(authorId.length > 0 ? authorId: @"Untitled")];
        
        [dateTaken addObject:[NSString stringWithFormat:@"%@",[image objectForKey:@"date_taken"]]];

        NSString *largeImageUrl = [NSString stringWithFormat:@"%@",[[image objectForKey:@"media"] objectForKey:@"m"]];
        [largeImageUrlArray addObject:largeImageUrl];

        
        NSString *smallImageUrl = [largeImageUrl stringByReplacingOccurrencesOfString:@"_m" withString:@"_s"];
        [smallImageUrlArray addObject:smallImageUrl];

        totalImageNo = authorIds.count;
    }

    for (int i=0; i< smallImageUrlArray.count; i++) {
        
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:
                                                    [NSURL URLWithString:[smallImageUrlArray objectAtIndex:i]]]];
        [smallImageArray addObject:image];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
