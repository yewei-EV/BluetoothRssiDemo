//
//  TriangulationAlgorithm.m
//  BabyBluetoothAppDemo
//
//  Created by Wu Cecilia on 2018-02-19.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TriangulationAlgorithm.h"

@implementation TriangulationCalculator


- (instancetype)init
{
    self = [super init];
    if (self) {
        //initialize the positions of the 5 beacons
        beaconPosition[0].h=5;
        beaconPosition[0].v=5;
        beaconPosition[1].h=8;
        beaconPosition[1].v=5;
        beaconPosition[2].h=6.5;
        beaconPosition[2].v=2.5;
    }
    return self;
}

- (Point) calculatePosition: (int)beaconId1 beaconId2:(int)beaconId2 beaconId3:(int)beaconId3 beaconDis1:(float)beaconDis1 beaconDis2:(float)beaconDis2 beaconDis3:(float)beaconDis3
{
    Point positionCoordinate;
    positionCoordinate.h = 0;
    positionCoordinate.v = 0;
    
    float BeaconDistanceOne   = beaconDis1;
    float BeaconDistanceTwo   = beaconDis2;
    float BeaconDistanceThree = beaconDis3;
    
    
    
    float beaconOneCoordinateX      = beaconPosition[0].h;
    float beaconOneCoordinateY      = beaconPosition[0].v;
    

    float beaconTwoCoordinateX      = beaconPosition[1].h;
    float beaconTwoCoordinateY      = beaconPosition[1].v;
    
    float beaconThreeCoordinateX    = beaconPosition[2].h;
    float beaconThreeCoordinateY    = beaconPosition[2].v;
    
    
    //Calculating Distances with Factor (cm to Pixel)   *1 = Factor cm to Pixel
    BeaconDistanceOne   = (BeaconDistanceOne * 100)     *1;
    BeaconDistanceTwo   = (BeaconDistanceTwo * 100)     *1;
    BeaconDistanceThree = (BeaconDistanceThree * 100)   *1;
    
    
    //Calculating Delta Alpha Beta
    float Delta   = 4 * ((beaconOneCoordinateX - beaconTwoCoordinateX) * (beaconOneCoordinateY - beaconThreeCoordinateY) - (beaconOneCoordinateX - beaconThreeCoordinateX) * (beaconOneCoordinateY - beaconTwoCoordinateY));
    float Alpha   = (BeaconDistanceTwo * BeaconDistanceTwo) - (BeaconDistanceOne * BeaconDistanceOne) - (beaconTwoCoordinateX * beaconTwoCoordinateX) + (beaconOneCoordinateX * beaconOneCoordinateX) - (beaconTwoCoordinateY * beaconTwoCoordinateY) + (beaconOneCoordinateY * beaconOneCoordinateY);
    float Beta    = (BeaconDistanceThree * BeaconDistanceThree) - (BeaconDistanceOne * BeaconDistanceOne) - (beaconThreeCoordinateX * beaconThreeCoordinateX) + (beaconOneCoordinateX * beaconOneCoordinateX) - (beaconThreeCoordinateY * beaconThreeCoordinateY) + (beaconOneCoordinateY * beaconOneCoordinateY);
    
    
    
    //Real Calculating the Position (Triletaration
    float PositionX = (1/Delta) * (2 * Alpha * (beaconOneCoordinateY - beaconThreeCoordinateY) - 2 * Beta * (beaconOneCoordinateY - beaconTwoCoordinateY));
    float PositionY = (1/Delta) * (2 * Beta * (beaconOneCoordinateX - beaconTwoCoordinateX) - 2 * Alpha * (beaconOneCoordinateX - beaconThreeCoordinateX));
    
    
    NSLog(@"PositionX = %f", PositionX);
    NSLog(@"PositionX = %f", PositionY);
    
    positionCoordinate.h = PositionX;
    positionCoordinate.v = PositionY;
    return positionCoordinate;
}



@end