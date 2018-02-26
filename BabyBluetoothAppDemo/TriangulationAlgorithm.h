//
//  TriangulationAlgorithm.h
//  BluetoothAppDemo
//
//  Created by Wu Cecilia on 2018-02-19.
//  Copyright © 2018 刘彦玮. All rights reserved.
//

#ifndef TriangulationAlgorithm_h
#define TriangulationAlgorithm_h


@interface TriangulationCalculator:NSObject
{
    //NSMutableArray *beaconPositionX;
    //NSMutableArray *beaconPositionY;
    Point beaconPosition [3];
    //double beaconPositionY[3];
    
}
- (Point) calculatePosition:(int)beaconId1 beaconId2:(int)beaconId2 beaconId3:(int)beaconId3 beaconDis1:(float)beaconDis1 beaconDis2:(float)beaconDis2 beaconDis3:(float)beaconDis3;
@end

#endif /* TriangulationAlgorithm_h */
