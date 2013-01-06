//
//  CustomCell.m
//  TableViewCustomEditControls
//
//  Created by Tieme van Veen on 1/4/13.
//  Copyright (c) 2013 Tieme van Veen. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize controlButton, currentState, previousState;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//is not used here beause we're loading from storyboard

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        //add our custom controlbutton to view
        controlButton = [[UIImageView alloc] initWithFrame:CGRectZero]; //(Watch it, Automatic Reference Counting is used here!)
        [self addSubview:controlButton]; //to the view, not to the contentView!
        
        //default states
        previousState = CustomCellStateDefaultMask;
        currentState = CustomCellStateDefaultMask;
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)newState{
    [super willTransitionToState:newState];
            
    //Animate button in in the next [self layoutsubviews] call
    if(newState == UITableViewCellStateShowingEditControlMask && [self currentState] == CustomCellStateDefaultMask){
        [self setPreviousState:CustomCellStateDefaultMask];
        [self setCurrentState:CustomCellStateShowingEditControlMask];
    }
    
    //Animate button out in the next [self layoutsubviews] call
    if(newState == UITableViewCellStateDefaultMask && [self currentState] == CustomCellStateShowingEditControlMask){
        [self setPreviousState:CustomCellStateShowingEditControlMask];
        [self setCurrentState:CustomCellStateDefaultMask];
    }
    
    //Turn button 90 degrees ccw in the next [self layoutsubviews] call
    if(newState == 3 && [self currentState] == CustomCellStateShowingEditControlMask){
        
        //Apperantly apple's not only using
            //UITableViewCellStateDefaultMask
            //UITableViewCellStateShowingEditControlMask
            //UITableViewCellStateShowingDeleteConfirmationMask
        //but also onther 4th type which is used here.
        
        [self setPreviousState:CustomCellStateShowingEditControlMask];
        [self setCurrentState:CustomCellStateShowingDeleteConfirmationMask];
    }
    
    //Turn delete button 90 degrees cw in the next [self layoutsubviews] call
    if(newState == UITableViewCellStateShowingEditControlMask && [self currentState] == CustomCellStateShowingDeleteConfirmationMask){
        [self setPreviousState:CustomCellStateShowingDeleteConfirmationMask];
        [self setCurrentState:CustomCellStateShowingEditControlMask];
    }
}

-(void) layoutSubviews {
    [super layoutSubviews];
    
    //current frame
    CGRect newFrame = self.controlButton.frame;
    newFrame.origin.y = (self.frame.size.height - self.controlButton.image.size.height) * 0.5;
    newFrame.size = self.controlButton.image.size;
    
    if([self previousState] == CustomCellStateDefaultMask && [self currentState] == CustomCellStateShowingEditControlMask){
        
        //show button!
        newFrame.origin.x = 12;
        self.controlButton.transform = CGAffineTransformMakeRotation(0);
        
    }else if([self previousState] == CustomCellStateShowingEditControlMask && [self currentState] == CustomCellStateShowingDeleteConfirmationMask){
        
        //90 degrees clockwise
        self.controlButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    }else if([self previousState] == CustomCellStateShowingDeleteConfirmationMask && [self currentState] == CustomCellStateShowingEditControlMask){

        //reset rotation
        self.controlButton.transform = CGAffineTransformMakeRotation(0);
        
    }else{
        //hide button left of the cell
        newFrame.origin.x = -self.controlButton.image.size.width;
    }
    
    //remove original button (UIkit might have regenerated it)
    if([self currentState] != CustomCellStateDefaultMask){
        [self removeOriginalEditControl];
    }
    
    self.controlButton.frame = newFrame;
}

//helper
- (void) removeOriginalEditControl{
    //remove apple's delete or add button
    for (UIView *subview in self.subviews) {
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]) {
            for (UIView *subsubview in subview.subviews) {
                if ([NSStringFromClass([subsubview class]) isEqualToString:@"UIImageView"]) {
                    [subsubview removeFromSuperview];
                    break;
                }
            }
        }
    }
}

@end
