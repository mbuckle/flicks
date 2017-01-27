//
//  ViewController.m
//  Flicks
//
//  Created by  Matthew Buckle on 1/23/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import "ViewController.h"
#import "MovieCell.h"
#import "MovieCollectionViewCell.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "DetailedViewController.h"

@interface ViewController () <UITableViewDataSource, UICollectionViewDataSource>

@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewControl;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController

NSString *urlString = @"";
NSString *apiKey = @"11329f6bab5f3a15ccad48c08dea6ed3";
bool isPullToRefresh = false;
NSUserDefaults *defaults;
NSInteger viewControlDefaultIndex;
MBProgressHUD *HUD;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.movieTableView.dataSource = self;
    self.movieCollectionView.dataSource = self;
    
    // Set background color
    UIColor *viewBackgroundColor = [UIColor colorWithRed:123.0f/255.0f
                                                   green:0.0f/255.0f
                                                    blue:153.0f/255.0f
                                                   alpha:1.0f];
    self.view.backgroundColor = viewBackgroundColor;
    self.movieTableView.backgroundColor = viewBackgroundColor;
    self.movieCollectionView.backgroundColor = viewBackgroundColor;
    
    // Hide either the table or grid view depending on stored segmented control settings
    defaults = [NSUserDefaults standardUserDefaults];
    viewControlDefaultIndex = [defaults integerForKey:@"viewControlDefaultIndex"];
    self.viewControl.selectedSegmentIndex = viewControlDefaultIndex;
    
    [self hideViewControl];
    
    // Implement UI Refresh Control
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    // Implement UI Loading HUD
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Need to register view if it is not set up in interface builder
    //[self.movieTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"movieCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    // Get the segmented control settings from persistent data
    defaults = [NSUserDefaults standardUserDefaults];
    viewControlDefaultIndex = [defaults integerForKey:@"viewControlDefaultIndex"];
    self.viewControl.selectedSegmentIndex = viewControlDefaultIndex;
    
    // Set title and url depending on which tab we are in
    if ([self.restorationIdentifier isEqualToString:@"now_playing"]) {
        urlString = [@"https://api.themoviedb.org/3/movie/now_playing?api_key=" stringByAppendingString:apiKey];
        self.title = @"Now Playing";
    } else if ([self.restorationIdentifier isEqualToString:@"top_rated"]) {
        urlString = [@"https://api.themoviedb.org/3/movie/top_rated?api_key=" stringByAppendingString:apiKey];
        self.title = @"Top Rated";
    }
    
    // Hide the table or grid view depending on stored segmented control settings
    [self hideViewControl];
    [self fetchMovies];
}

- (IBAction)onValueChange:(UISegmentedControl *)sender {
    [self hideViewControl];
    [self fetchMovies];
    [self saveDefaults];
}

- (void) saveDefaults {
    // Get currently selected segment
    NSInteger viewControlIndex = self.viewControl.selectedSegmentIndex;
    
    // Save selected segment to user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:viewControlIndex forKey:@"viewControlDefaultIndex"];
    [defaults synchronize];
}

- (void)hideViewControl {
    if (self.viewControl.selectedSegmentIndex == 0) {
        [self.movieTableView setHidden:false];
        [self.movieCollectionView setHidden:true];
        [self.movieTableView insertSubview:self.refreshControl atIndex:0];
    } else if (self.viewControl.selectedSegmentIndex == 1) {
        [self.movieTableView setHidden:true];
        [self.movieCollectionView setHidden:false];
        [self.movieCollectionView insertSubview:self.refreshControl atIndex:0];
    }
}

- (void)refreshTable {
    isPullToRefresh = true;
    [self fetchMovies];
}

- (void)fetchMovies
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate:nil
                             delegateQueue:[NSOperationQueue mainQueue]];
    
    // Display HUD right before the request is made
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    // Un-hide view if it was previously hidden due to network error
                                                    //[self.movieTableView setHidden:false];
                                                    
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];
                                                    
                                                    NSArray *results = responseDictionary[@"results"];
                                                    
                                                    NSMutableArray *models = [NSMutableArray array];
                                                    for (NSDictionary *result in results) {
                                                        MovieModel *model = [[MovieModel alloc] initWithDictionary:result];
                                                        [models addObject:model];
                                                    }
                                                    self.movies = models;
                                                    [self.movieTableView reloadData];
                                                    [self.movieCollectionView reloadData];
                                                    
                                                } else {
                                                    // Hide view and display an error
                                                    [self.movieTableView setHidden:true];
                                                    [self.movieCollectionView setHidden:true];
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                                // Hide HUD once the network request comes back (either success or fail -- must be done on main UI thread)
                                                [MBProgressHUD hideHUDForView:self.view animated:true];
                                                
                                                // Hide the pull-to-refresh animation once the network request comes back (either success or fail)
                                                if (isPullToRefresh) {
                                                    [self.refreshControl endRefreshing];
                                                    isPullToRefresh = false;
                                                }
                                            }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieCell"];
    //[cell.titleLabel setText:[NSString stringWithFormat:@"Title - %ld", indexPath.row]];
    //[cell.overviewLabel setText:[NSString stringWithFormat:@"Overview - %ld", indexPath.row]];
    //[cell.posterImage setImage:[UIImage imageNamed:@"YahooIcon.png"]];
    
    MovieCell* cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.overviewLabel.text = model.overview;
    [cell.overviewLabel sizeToFit];
    cell.releaseDateInfo = model.releaseDate;
    cell.ratingInfo = model.rating;
    
    // Set poster image async
    cell.posterImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterImage setImageWithURL:model.posterURL];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionViewCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    
    // Set poster image async
    cell.posterImage.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterImage setImageWithURL:model.posterURL];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailedViewController *detailedViewController = [segue destinationViewController];
    NSString *senderClass = NSStringFromClass([sender class]);
    
    NSIndexPath *indexPath;
    if ([senderClass isEqualToString:@"MovieCell"]) {
        indexPath = [self.movieTableView indexPathForCell:sender];
    } else if ([senderClass isEqualToString:@"MovieCollectionViewCell"]) {
        indexPath = [self.movieCollectionView indexPathForCell:sender];
    }
    
    detailedViewController.detailedMovieModel = [self.movies objectAtIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
