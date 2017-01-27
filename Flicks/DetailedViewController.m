//
//  DetailedViewController.m
//  Flicks
//
//  Created by  Matthew Buckle on 1/24/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import "DetailedViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailedViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView  *cardView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieOverviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieReleaseDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;

@end

@implementation DetailedViewController

UIColor *labelTextColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    labelTextColor = [UIColor whiteColor];
    
    // Set up scroll view and card view
    self.scrollView.contentInset = UIEdgeInsetsMake(150, 0, 0, 0);
    CGFloat contentOffsetY = 180 + CGRectGetHeight(self.cardView.bounds);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentOffsetY);
    //self.scrollView.backgroundColor = [UIColor yellowColor];
    self.cardView.backgroundColor = [UIColor blackColor];
    self.cardView.alpha = 0.7;
    
    // Set up movie details
    self.moviePosterImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.moviePosterImageView setImageWithURL:self.detailedMovieModel.posterURL];
    
    self.movieTitleLabel.text = self.detailedMovieModel.title;
    self.movieTitleLabel.textColor = labelTextColor;
    
    self.movieOverviewLabel.text = self.detailedMovieModel.overview;
    self.movieOverviewLabel.textColor = labelTextColor;
    [self.movieOverviewLabel sizeToFit];
    
    // Format the movie release date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:self.detailedMovieModel.releaseDate];
    [dateFormatter setDateFormat:@"MMMM d, yyyy"];
    NSString *movieReleaseDateString = [dateFormatter stringFromDate:date];
    
    self.movieReleaseDateLabel.text = [NSString stringWithFormat:@"In theaters on\n%@", movieReleaseDateString];
    self.movieReleaseDateLabel.textColor = labelTextColor;
    
    self.movieRatingLabel.text = [NSString stringWithFormat:@"Rated\n%0.1f out of 10", [self.detailedMovieModel.rating floatValue]];
    self.movieRatingLabel.textColor = labelTextColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
