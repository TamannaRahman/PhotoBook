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
    
    authorIds = [[NSMutableArray alloc] init];
    dateTaken = [[NSMutableArray alloc] init];
    smallImageUrls = [[NSMutableArray alloc] init];
    largeImageUrls = [[NSMutableArray alloc] init];
    
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
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    header.backgroundColor = [UIColor darkGrayColor];
    header.textColor = [UIColor whiteColor];
    header.text = @"PHOTO BOOK";
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont fontWithName:@"Georgia-Bold" size:30];
    [self.view addSubview:header];

    
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
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor darkGrayColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 160);
}

-(void)fetchFlickrPublicImages
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=data"];
  //  http://api.flickr.com/services/feeds/photos_public.gne?tags=hackdayindia&lang=en-us&format=json&nojsoncallback=1
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@", url);
    
    NSData *badJSON = [NSData dataWithContentsOfURL:url];
    NSString *dataAsString = [NSString stringWithUTF8String:[badJSON bytes]];
    NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:kNilOptions error:&error];
    NSLog(@"json %@",json);

    NSArray *images = [json objectForKey:@"items"];
    for (NSDictionary *image in images)
    {
        NSString *authorId = [image objectForKey:@"author_id"];
        
        [authorIds addObject:(authorId.length > 0 ? authorId: @"Untitled")];
        
        
        NSString *largeImageUrl = [NSString stringWithFormat:@"%@",[[image objectForKey:@"media"] objectForKey:@"m"]];
        
        NSString *smallImageUrl = [largeImageUrl stringByReplacingOccurrencesOfString:@"_m" withString:@"_s"];
        
        [smallImageUrls addObject:smallImageUrl];

        [dateTaken addObject:[NSString stringWithFormat:@"%@",[image objectForKey:@"date_taken"]]];
        [largeImageUrls addObject:[NSString stringWithFormat:@"%@",[[image objectForKey:@"media"] objectForKey:@"m"]]];
       
        
    }
    NSLog(@"authorIds: %@\n\n", authorIds);
    NSLog(@"photoURLsLareImage: %@\n\n", smallImageUrls);

    NSLog(@"photoURLsLareImage: %@\n\n", largeImageUrls);

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
