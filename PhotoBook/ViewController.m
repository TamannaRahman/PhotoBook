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
    
    authorNames = [[NSMutableArray alloc] init];
    dateTaken = [[NSMutableArray alloc] init];
    imageTitles = [[NSMutableArray alloc] init];
    smallImageUrlArray = [[NSMutableArray alloc] init];
    largeImageUrlArray = [[NSMutableArray alloc] init];
    smallImageArray = [[NSMutableArray alloc] init];
    cachedImage = [NSMutableDictionary new];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(60, 20, 20, 20);
   
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_collectionView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_collectionView];
    
    [self fetchFlickrPublicImages];
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return totalImageNo;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
   
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"placeholder"]];

    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    
    imageView.image = nil;
    
    if ([smallImageUrlArray count] >0){
        
        //check if image already downloaded, if yes just use
        if(cachedImage[[smallImageUrlArray objectAtIndex:indexPath.row]] != nil){
            imageView.image = cachedImage[[smallImageUrlArray objectAtIndex:indexPath.row]];
            cell.backgroundView = [[UIImageView alloc] initWithImage:cachedImage[[smallImageUrlArray objectAtIndex:indexPath.row]]];
        }
        else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:[smallImageUrlArray objectAtIndex:indexPath.row]]];
                UIImage *image = [UIImage imageWithData: data];
                
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    imageView.image = image;
                    cachedImage[[smallImageUrlArray objectAtIndex:indexPath.row]] = image; //****SAVEd DOWNLOADED IMAGE
                });
            });
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *getLargeImageUrl = [largeImageUrlArray objectAtIndex:indexPath.row];
    
    SingleImageViewController *singleView = [[SingleImageViewController alloc] init];
    singleView.singleImageUrlData = getLargeImageUrl;
    singleView.imageMetaData = [NSString stringWithFormat:@"Author Id: %@\nImage Capture Date: %@\nTitle: %@",
                                [authorNames objectAtIndex:indexPath.row],
                                [dateTaken objectAtIndex:indexPath.row],
                                [imageTitles objectAtIndex:indexPath.row],nil];
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
    
    NSString *correctedJSONString = [NSString stringWithString:
                                     [dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:kNilOptions error:&error];

    NSArray *images = [json objectForKey:@"items"];
    
    for (NSDictionary *image in images)
    {
        NSString *author = [image objectForKey:@"author"];
        [authorNames addObject:(author.length > 0 ? author: @"Untitled")];
        
        [dateTaken addObject:[NSString stringWithFormat:@"%@",[image objectForKey:@"date_taken"]]];
        [imageTitles addObject:[NSString stringWithFormat:@"%@",[image objectForKey:@"title"]]];
        
        NSString *largeImageUrl = [NSString stringWithFormat:@"%@",[[image objectForKey:@"media"] objectForKey:@"m"]];
        [largeImageUrlArray addObject:largeImageUrl];

        NSString *smallImageUrl = [largeImageUrl stringByReplacingOccurrencesOfString:@"_m" withString:@"_s"];
        [smallImageUrlArray addObject:smallImageUrl];

        totalImageNo = authorNames.count;
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
