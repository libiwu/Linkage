//
//  FormOptionsViewController.h
//  Linkage
//
//  Created by Mac mini on 16/4/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormOptionsViewController : UIViewController<XLFormRowDescriptorViewController>
@property (nonatomic, strong) NSArray *options;
@end


@interface CompanyOptionsViewController : FormOptionsViewController

@end
