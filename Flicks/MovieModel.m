//
//  MovieModel.m
//  Flicks
//
//  Created by  Matthew Buckle on 1/23/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import "MovieModel.h"

@implementation MovieModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.title = dictionary[@"original_title"];
        self.overview = dictionary[@"overview"];
        NSString *urlString = [NSString stringWithFormat:@"https://image.tmdb.org/t/p/w342/%@", dictionary[@"poster_path"]];
        self.posterURL = [NSURL URLWithString:urlString];
        self.releaseDate = dictionary[@"release_date"];
        self.rating = dictionary[@"vote_average"];
    }
    
    return self;
}



@end
