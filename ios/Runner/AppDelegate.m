#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
// #import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // [GMSServices provideAPIKey:@"AIzaSyAbhJpKCspO0OX3udKg6shFr5wwHw3yd_E"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
