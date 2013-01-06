//
//  CustomCell.h
//  TableViewCustomEditControls
//
//  Created by Tieme van Veen on 1/4/13.
//  Copyright (c) 2013 Tieme van Veen. All rights reserved.
//

#import <UIKit/UIKit.h>

//states our cell could be in
typedef NS_OPTIONS(NSUInteger, CustomCellState) {
    CustomCellStateDefaultMask,
    CustomCellStateShowingEditControlMask,
    CustomCellStateShowingDeleteConfirmationMask,
};

@interface CustomCell : UITableViewCell

@property (nonatomic, strong) UIImageView *controlButton;

@property (nonatomic, assign) CustomCellState currentState;
@property (nonatomic, assign) CustomCellState previousState;

@end
