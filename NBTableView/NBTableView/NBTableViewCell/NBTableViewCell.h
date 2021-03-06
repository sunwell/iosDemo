//
//  NBTableViewCell.h
//  NBTableView
//
//  Created by sunwell on 2016/10/27.
//  Copyright © 2016年 sunwell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBGlobalDefines.h"
#import "NBCellActionsView.h"
#import "NBSeparationLine.h"

@interface NBTableViewCell : UIView

DEFINE_PROPERTY_ASSIGN(BOOL, isSelected);
DEFINE_PROPERTY_ASSIGN(NSInteger, index);
DEFINE_PROPERTY_STRONG(NSString *, identifiy);
DEFINE_PROPERTY_STRONG(UIView *, selectedBackgroundView);
DEFINE_PROPERTY_STRONG(NBCellActionsView *, actionsView);
DEFINE_PROPERTY_STRONG(UIView *, contentView);
DEFINE_PROPERTY_STRONG(UILabel *, textLabel);

DEFINE_PROPERTY_STRONG(NBSeparationLine *, topSeparationLine);
DEFINE_PROPERTY_STRONG(NBSeparationLine *, bottomSeparationLine);

- (instancetype)initWithIdentifiy:(NSString *)identifiy;
- (void) showGradientStart:(UIColor *)startColor endColor:(UIColor *)end;
- (void)prepareForReused;
@end
