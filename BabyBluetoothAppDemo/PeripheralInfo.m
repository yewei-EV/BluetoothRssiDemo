//
//  PeripheralInfo.m
//  BabyBluetoothAppDemo
//

#import "PeripheralInfo.h"

@implementation PeripheralInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        _characteristics = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
