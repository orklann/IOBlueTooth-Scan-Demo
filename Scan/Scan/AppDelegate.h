//
//  AppDelegate.h
//  Scan
//
//  Created by Khaos Tian on 6/12/12.
//  Copyright (c) 2012 Oltica. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <IOBluetooth/IOBluetooth.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, IOBluetoothDeviceInquiryDelegate, IOBluetoothDevicePairDelegate, IOBluetoothL2CAPChannelDelegate>{
    IOBluetoothDevicePair *pair;
    IOBluetoothDeviceInquiry *central;
    IOBluetoothDevice *magicMouse;
    IOBluetoothL2CAPChannel *channel;
}
@end
