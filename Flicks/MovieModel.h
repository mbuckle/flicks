//
//  MovieModel.h
//  Flicks
//
//  Created by  Matthew Buckle on 1/23/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

// define properties which include getters/setters
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *overview;
@property (nonatomic, strong) NSURL    *posterURL;
@property (nonatomic, strong) NSString *releaseDate;
@property (nonatomic, strong) NSNumber *rating;

@end
