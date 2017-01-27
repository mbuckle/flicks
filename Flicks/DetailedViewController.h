//
//  DetailedViewController.h
//  Flicks
//
//  Created by  Matthew Buckle on 1/24/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import "ViewController.h"
#import "MovieModel.h"

@class MovieModel;

@interface DetailedViewController : ViewController

@property (strong, nonatomic) MovieModel *detailedMovieModel;

@property (weak, nonatomic) IBOutlet UIImageView *moviePosterImageView;

@end
