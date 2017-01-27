//
//  ViewController.h
//  Flicks
//
//  Created by  Matthew Buckle on 1/23/17.
//  Copyright © 2017 Matthew Buckle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *movieTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *movieCollectionView;

@end

