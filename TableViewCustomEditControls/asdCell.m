//
//  asdCell.m
//  TableViewCustomEditControls
//
//  Created by Tieme van Veen on 1/4/13.
//  Copyright (c) 2013 Tieme van Veen. All rights reserved.
//

#import "asdCell.h"

@implementation asdCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
