//
//  MovieCell.m
//  Flicks
//
//  Created by  Matthew Buckle on 1/23/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithRed:123.0f/255.0f
                                           green:0.0f/255.0f
                                            blue:153.0f/255.0f
                                           alpha:1.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
