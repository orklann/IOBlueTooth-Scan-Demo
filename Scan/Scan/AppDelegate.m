//
//  AppDelegate.m
//  Scan
//
//  Created by Khaos Tian on 6/12/12.
//  Copyright (c) 2012 Oltica. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    central = [[IOBluetoothDeviceInquiry alloc] initWithDelegate:self];
    [central setSearchType:kIOBluetoothDeviceSearchClassic];
    [central setInquiryLength:20];
    [central setUpdateNewDeviceNames:NO];
    [central start];
}

- (void)deviceInquiryStarted:(IOBluetoothDeviceInquiry *)sender {
    NSLog(@"Scan started...");
}

- (void)deviceInquiryDeviceFound:(IOBluetoothDeviceInquiry *)sender
                          device:(IOBluetoothDevice *)device {
    NSLog(@"%@", device.name);
    if ([device.name isEqualToString:@"Aaron Elkins’s Mouse"]) {
        [central stop];
        magicMouse = device;
        //NSLog(@"%@", device);
    }
}

- (void)deviceInquiryComplete:(IOBluetoothDeviceInquiry*)ssender
                         error:(IOReturn) error
                       aborted:(BOOL) aborted
{
    IOBluetoothL2CAPChannel *l2cap;
    IOReturn r = [magicMouse openL2CAPChannelSync:&l2cap withPSM:17 delegate:self];
    if (r == kIOReturnSuccess) {
        NSLog(@"Connect to L2CAP success");
        channel = l2cap;
    } else {
        NSLog(@"Open L2CAP error");
        channel = nil;
    }
}

- (void)l2capChannelData:(IOBluetoothL2CAPChannel *)l2capChannel
                    data:(void *)dataPointer
                  length:(size_t)dataLength {
    NSLog(@"Get mouse data len: %ld", dataLength);
}

- (void)l2capChannelOpenComplete:(IOBluetoothL2CAPChannel *)l2capChannel status:(IOReturn)error {
    NSLog(@"L2CAP open done");
    [l2capChannel writeSync:@"HELLO" length:5];
}

- (void)l2capChannelClosed:(IOBluetoothL2CAPChannel *)l2capChannel {
    NSLog(@"L2CAP closed");
}

- (void)l2capChannelWriteComplete:(IOBluetoothL2CAPChannel *)l2capChannel refcon:(void *)refcon status:(IOReturn)error {
    NSLog(@"Write to l2cap done");
}
@end
