//
//  YTAdvsCell.m
//  YTADDemo
//
//  Created by chinatsp on 16/3/2.
//  Copyright © 2016年 chinatsp. All rights reserved.
//

#import "YTAdvsCell.h"
@interface YTAdvsCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation YTAdvsCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setImage:(NSString *)image
{
    _image = [image copy];
    
    self.imageView.image = [UIImage imageNamed:image];
}
@end
