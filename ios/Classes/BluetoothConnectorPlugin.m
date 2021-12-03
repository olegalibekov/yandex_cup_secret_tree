#import "BluetoothConnectorPlugin.h"
#if __has_include(<bluetooth_connector/bluetooth_connector-Swift.h>)
#import <bluetooth_connector/bluetooth_connector-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "bluetooth_connector-Swift.h"
#endif

@implementation BluetoothConnectorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBluetoothConnectorPlugin registerWithRegistrar:registrar];
}
@end
