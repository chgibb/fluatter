#import "FluatterPlugin.h"
#if __has_include(<fluatter/fluatter-Swift.h>)
#import <fluatter/fluatter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fluatter-Swift.h"
#endif

@implementation FluatterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFluatterPlugin registerWithRegistrar:registrar];
}
@end
