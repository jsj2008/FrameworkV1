//
//  UFDataPickerInput.m
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFDataPickerInput.h"

@interface UFDataPickerInput () <UFDataPickInputAccessoryDelegate>
{
    UFDataPicker *_dataPicker;
    
    id<UFDataPickInputAccessory> _accessory;
}

@end


@implementation UFDataPickerInput

@synthesize dataPicker = _dataPicker;

@synthesize accessory = _accessory;

- (instancetype)initWithDataPicker:(UFDataPicker *)dataPicker accessory:(id<UFDataPickInputAccessory>)accessory
{
    if (self = [super init])
    {
        _dataPicker = dataPicker;
        
        _accessory = accessory;
        
        _accessory.dataPickInputAccessoryDelegate = self;
    }
    
    return self;
}

- (void)setIndexes:(NSArray *)indexes animated:(BOOL)animated
{
    [self.dataPicker setIndexes:indexes animated:animated];
}

- (void)dataPickInputAccessoryDidConfirm:(id)accessory
{    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickerInput:didSelectIndexes:)])
    {
        [self.delegate dataPickerInput:self didSelectIndexes:[self.dataPicker currentIndexes]];
    }
}

- (void)dataPickInputAccessoryDidCancel:(id)accessory
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataPickerInputDidCancel:)])
    {
        [self.delegate dataPickerInputDidCancel:self];
    }
}

@end
