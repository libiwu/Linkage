//
//  DriverViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "DriverViewController.h"
#import "Driver.h"
#import "DriverUtil.h"
#import "AddDriverViewController.h"

@interface DriverViewController()<ModelBaseControllerConfigure>

@end

@implementation DriverViewController

-(Class)modelUtilClass
{
    return [DriverUtil class];
}

-(Class)viewControllerClass
{
    return [AddDriverViewController class];
}

@end