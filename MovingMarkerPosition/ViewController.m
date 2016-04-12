#import "ViewController.h"
@import GoogleMaps;
@import CoreLocation;

@interface ViewController () <GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate>

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
- (IBAction)animateButton:(id)sender;
@property (nonatomic, strong) GMSMarker *marker;
@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

#pragma mark - ViewController class extension methods

- (IBAction)animateButton:(id)sender {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];

    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setTarget:place.coordinate zoom:8.0f]];
    
    self.marker.map = nil;
    self.marker = [GMSMarker markerWithPosition:place.coordinate];
    self.marker.map = self.mapView;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
@end
