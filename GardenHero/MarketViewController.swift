//
//  MarketViewController.swift
//  GardenHero
//
//  Created by 朱莎 on 12/9/19.
//  Copyright © 2019 Monash University. All rights reserved.
//

import UIKit
import MapKit

class MarketViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var marketMapView: MKMapView!
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    var marketAnnotations: [Market] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        marketMapView.delegate = self

        configureLocationServices()
        
        addAnnotations()
        focusLocation(coordinate: CLLocationCoordinate2D(latitude: -37.876823,  longitude: 145.045837))
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    // Get user authorize// Xiugai
    func configureLocationServices(){
        let status = CLLocationManager.authorizationStatus()
        if  status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else if status == . authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManger: locationManager)
    }
    }
    
    func beginLocationUpdates(locationManger: CLLocationManager){
        marketMapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    
   
    
    
    
    func focusLocation(coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        marketMapView.setRegion(marketMapView.regionThatFits(zoomRegion), animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate != nil{
            addAnnotations()
        }
        currentCoordinate = latestLocation.coordinate
       
        
    }
    
   
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("The status changed")
        if status == . authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManger: manager)
        }
    }
    var currentPlacemark: CLPlacemark?
    func addAnnotations(){
        addMarket()
        for marketAnnotation in marketAnnotations{
            self.marketMapView.addAnnotation(marketAnnotation) // add annotation to map view

        }
        
    }
    
    @IBAction func showDirection(_ sender: Any) {
        guard let currentPlacemark = currentPlacemark else{
            return
        }
        let directionRequest = MKDirections.Request()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        // calculate the directions/ route
        let directions = MKDirections(request: directionRequest)
        directions.calculate{ (directionResponse, error) in
            guard let directionResponse = directionResponse else {
                if let error = error {
                    print("error getting directions: \(error.localizedDescription)")
                }
                return
            }
            
            let route = directionResponse.routes[0]
            
            self.marketMapView.removeOverlays(self.marketMapView.overlays)
            
           
            self.marketMapView.addOverlay(route.polyline, level: .aboveRoads)
            let routeRect = route.polyline.boundingMapRect
            self.marketMapView.setRegion(MKCoordinateRegion(routeRect), animated: true)
            
            
        }
    }
    
    
    func addMarket(){
        marketAnnotations.append(Market(newTitle: " Ararat Seasonal Farmers Markets", newSubtitle: " Address: Alexandra Lakeside Gardens, Vincent St, Ararat, Opening: 2nd Sunday 9am - 1pm ",
                                        lat: -37.2852915,
                                        long: 142.9307639))
        
            
            marketAnnotations.append(Market(newTitle: " Avenel Market ",
            newSubtitle: " Address: Jubilee Park, Queen St, Avenel, Opening: 2nd Sunday 9am - 1pm ",
            lat: -36.8963154,
            long: 145.2298609))
            
             marketAnnotations.append(Market(newTitle: "Ballan & District Farmers Market", newSubtitle: " Address: Mill Cottage, 92 Inglis Street, Ballan, Opening: 2nd Saturday, 9am - 1pm ",
                 lat: -37.5999465,
                 long: 144.2297601))
            
            marketAnnotations.append(Market( newTitle: " Ballarat Lakeside Farmers Market ", newSubtitle: " Address: Wendourie Pde opposite the Botanical Gardens, Ballarat, Opening: 2nd + 4th Saturday, 9 am - 1 pm ",
                                                            lat: -37.5462869,
                                                            long: 143.8214056))
            
            marketAnnotations.append(Market(newTitle: " Bayside Farmers Market ",
            newSubtitle: " Address: Trey Bit Reserve, Jetty Road, Sandringham, Opening: Third Saturday, 8am - 1pm ",
            lat: -37.9458019,
            long: 144.9976629))
            
            marketAnnotations.append(Market(newTitle: " Bellarine Community Farmers Market ", newSubtitle: " Address: Ocean Grove Park, cnr of Presidents Ave & Draper St, Ocean Grove, Opening: Every 3rd Saturday 9am - 1pm ",
                                                              lat: -38.2652412,
                                                              long: 144.5235191))
            
            marketAnnotations.append(Market(newTitle: " Bendigo Community Farmers Market ", newSubtitle: " Address: Sydney Myer Place, Bendigo, Opening: 2nd Saturday, 9am - 1pm ",
                                                            lat: -36.7581085,
                                                            long: 144.2798128))
            
            marketAnnotations.append(Market(newTitle: " Bentleigh Farmers Market ",
            newSubtitle: " Address: Bentleigh East Primary School, 90 Bignell Rd, Bentleigh East, Opening: 4th Saturday, 8am -12.30pm ",
            lat: -37.9345579,
            long: 145.0694508))
            
            marketAnnotations.append(Market(newTitle: " Bonbeach Farmers Market ",
            newSubtitle: " Address: Bonbeach Primary School, Breeze Street, Bonbeach, Opening: 2nd Sunday, 9am-1pm Starts 12 October ",
            lat: -38.066542,
            long: 145.126012))
            
            marketAnnotations.append(Market(newTitle: " Boroondara Farmers Market ",
            newSubtitle: " Address: Patterson Reserve, Auburn Rd, East Hawthorn, Opening: 3rd Saturday 8am - 12.30pm ",
            lat: -37.8392275,
            long: 145.0395798))
            
            marketAnnotations.append(Market(newTitle: " Bundoora Park Farmers Market ", newSubtitle: " Address: Bundoora Park, Plenty Rd, Bundoora, Opening: 1st Saturday 8 am - 1 pm ",
                                                        lat: -37.7125606,
                                                        long: 145.046327))
            
            marketAnnotations.append(Market(newTitle: " Casey Berwick Farmers Market ", newSubtitle: " Address: The Old Cheese Factory, 34 Homestead Rd, Berwick, Opening: 4th Saturday 8am - 12.30pm ",
                                                        lat: -38.05431,
                                                        long: 145.333426))
            
            marketAnnotations.append(Market(newTitle: " Castlemaine Farmers Market ",
            newSubtitle: " Address: Moyston St next to Market Building, Castlemaine, Opening: 1st Sunday 9am - 1pm ",
            lat: -37.0659798,
            long: 144.2180797))
            
            marketAnnotations.append(Market(newTitle: " Churchill Island Farmers Market ", newSubtitle: " Address: Churchill Island Visitor Centre, Phillip Island, Opening: 4th Saturday 8am - 1pm ",
                                                           lat: -38.5150698,
                                                           long: 145.3479258))
            
            marketAnnotations.append(Market(newTitle: " Coal Creek Farmers Market ",
            newSubtitle: " Address: Coal Creek Community Park and Museum, Silkstone Road, Korumburra, Opening: 2nd Saturday, 8am - 12.30pm ",
            lat: -38.441984,
            long: 145.830546))
            
            marketAnnotations.append(Market(newTitle: " Coburg Farmers Market ",
            newSubtitle: " Address: Coburg North Primary School, 180 OHea Street, Coburg, Opening: 2nd + 4th Saturdays 8am - 1pm ",
            lat: -37.7357364,
            long: 144.951892))
            
            marketAnnotations.append(Market(newTitle: " Collingwood Childrens Farm Farmers Market ",
            newSubtitle: " Address: Collingwood Childrens Farm, 18 St Heliers St, Abbotsford, Opening: 2nd Saturday 8am - 1pm ",
            lat: -37.8021351,
            long: 145.0043186))
            
            marketAnnotations.append(Market(newTitle: " Croydon Farmers Market ",
            newSubtitle: " Address: Croydon Park, Hewish Rd, Croydon, Opening: 2nd Saturday 8am - 1pm ",
            lat: -37.7987778,
            long: 145.2841431))
            
            marketAnnotations.append(Market(newTitle: " Daylesford Farmers Market ",
            newSubtitle: " Address: Daylesford Primary School, Vincent St, Daylesford, Opening: 1st Saturday 8am - 1pm ",
            lat: -37.345127,
            long: 144.1414982))
            
            marketAnnotations.append(Market(newTitle: " East Gippsland Farmers Market ", newSubtitle: " Address: Secondary College Oval, McKean St, Bairnsdale, Opening: 1st Saturday 8am - 1pm ",
                                                         lat: -37.8251668,
                                                         long: 147.6052773))
            
            marketAnnotations.append(Market(newTitle: " Echuca Farmers Market ",
            newSubtitle: " Address: Alton Reserve, High Street, Echuca, Opening: 1st, 3rd and 5th Saturday 8am - 12pm ",
            lat: -36.12924599999999,
            long: 144.749559))
            
            marketAnnotations.append(Market(newTitle: " Eltham Farmers Market ",
            newSubtitle: " Address: Eltham Town Mall, 10-18 Arthur Street, Eltham, Opening: 2nd & 4th Sunday, 9am - 1pm ",
            lat: -37.7148799,
            long: 145.1497581))
            
            marketAnnotations.append(Market(newTitle: " Elwood Farmers Market ",
            newSubtitle: " Address: Elwood College, 101 Glenhuntley Road, Elwood, Opening: 2nd Saturday, 8.30am - 1pm ",
            lat: -37.8820981,
            long: 144.9846335))
            
            marketAnnotations.append(Market(newTitle: " Euroa Village Farmers Market ",
            newSubtitle: " Address: Rotary Park, Kirkland Ave, Euroa, Opening: 3rd Saturday, 9am- 1pm ",
            lat: -36.7523861,
            long: 145.5734516))
            
            marketAnnotations.append(Market(newTitle: " Eynesbury Farmers Market ",
            newSubtitle: " Address: 487 Eynesbury Road, Eynesbury, Opening: (Starting 18/10/2015) Every Sunday 9.30am - 2.30pm ",
            lat: -37.79088670000001,
            long: 144.5656824))
            
            marketAnnotations.append(Market(newTitle: " Fairfield Farmers Market ",
            newSubtitle: " Address: Fairfield Primary School, Wingrove Street, Fairfield, Opening: 3rd & 5th Saturdays of the month, 8am - 1pm ",
            lat: -37.7782813,
            long: 145.0212076))
            
            marketAnnotations.append(Market(newTitle: "Farmers Market @ The Old Cheese Factory",
            newSubtitle: " Address: The Old Cheese Factory, 34 Homestead Road, Berwick, Opening: Second Saturday, 8am - 12.30pm ",
            lat: -38.05431,
            long: 145.333426))
            
            marketAnnotations.append(Market(newTitle: " Fitzroy Street Farmers Market ",
            newSubtitle: " Address: cnr Fitzroy St & Lakeside Drive, St Kilda, Opening: 4th Saturdays, 8.30am - 1pm ",
            lat: -37.85951,
            long: 144.9779446))
            
            marketAnnotations.append(Market(newTitle: " Flemington Farmers Market ",
            newSubtitle: " Address: Mount Alexander College, 175 Mt Alexander Rd, Flemington, Opening: Every Sunday, 9am - 1pm ",
            lat: -37.782406,
            long: 144.933138))
            
            marketAnnotations.append(Market(newTitle: "Gasworks Farmers Market",
            newSubtitle: " Address: Gasworks Arts Park, 21 Graham St, Albert Park, Opening: 3rd Saturday 8am - 1pm ", lat: -37.8429687,
                                                                                                                      long: 144.9457415))
            
            marketAnnotations.append(Market(newTitle: " Golden Plains Farmers Market ",
            newSubtitle: " Address: cnr High Street + Milton Street, Bannockburn, Opening: 1st Saturday 8:30am - 12:30pm ",
            lat: -38.0466332,
            long: 144.1710478))
            
            marketAnnotations.append(Market(newTitle: " Heathcote Region Farmers Market  ", newSubtitle: " Address: Barrack Reserve, High Street, Heathcote,  Opening: 3rd Saturday, 9am - 1pm ",
                                                             lat: -36.9225292,
                                                             long: 144.7106587))
            
            marketAnnotations.append(Market(newTitle: " Heathmont Farmers Market ",
            newSubtitle: " Address: Great Ryrie Primary School, Great Ryrie St, Heathmont, Opening: 1st Sunday 9am - 1pm ",
            lat: -37.8235873,
            long: 145.237804))
            
           marketAnnotations.append(Market( newTitle: " Heyfield Market ",
            newSubtitle: " Address: John Graves Memorial Park, Temple St, Heyfield, Opening: First Saturday every month 8am onwards ",
            lat: -37.982622,
            long: 146.7849707))
            
            marketAnnotations.append(Market(newTitle: " Hume Murray Farmers Market  ", newSubtitle: " Address: Gateway Island, Lincoln Causeway, Albury - Wodonga, Opening: 2nd & 4th Saturdays 8am - 12 noon ",
                                                        lat: -36.0999949,
                                                        long: 146.8992584))
            
            marketAnnotations.append(Market(newTitle: " Hurstbridge Farmers Market ",
            newSubtitle: " Address: Fergusons Paddock, 12 Arthurs Creek Rd, Hurstbridge, Opening: 1st Sunday (except January) 8.30am - 1pm ",
            lat: -37.636359,
            long: 145.193338))
            
            marketAnnotations.append(Market(newTitle: " Inverloch Community Farmers Market ", newSubtitle: " Address: The Glade, Inverloch, Opening: Last Sunday, 8am - 1pm ",
                                                              lat: -38.6352425,
                                                              long: 145.7301527))
            
           marketAnnotations.append(Market( newTitle: " Inverloch Farmers Markets ",
            newSubtitle: " Address: The Glade, Inverloch, Opening: 3rd Sunday 8am - 1pm ",
            lat: -38.6352425,
            long: 145.7301527))
            marketAnnotations.append(Market(newTitle: " Kingston Farmers Market ",
            newSubtitle: " Address: Sir William Fry Reserve, cnr Nepean Highway + Bay Road (opposite Southland), Highett, Opening: 1st Saturday (except Jan), 8am - 12.30pm ",
            lat: -37.9554919,
            long: 145.0484107))
            
            marketAnnotations.append(Market(newTitle: " Koonawarra Farmers Market ",
            newSubtitle: " Address: Memorial Park, Koonwarra, Opening: 1st Saturday 8am - 12.30 pm ",
            lat: -38.5472852,
            long: 145.9457776))
            
            marketAnnotations.append(Market(newTitle: " Koondrook Barham Farmers Market ", newSubtitle: " Address: James Park, Koondrook, Opening: 3rd Sunday 9am - 1pm ",
                                                           lat: -35.631886,
                                                           long: 144.1250649))
            
            marketAnnotations.append(Market(newTitle: " Kyneton Farmers Market",
            newSubtitle: " Address: St Pauls Park, Piper St, Kyneton, Opening: 2nd Saturday 8am - 1pm ",
            lat: -37.2450344,
            long: 144.4494078))
            
            marketAnnotations.append(Market(newTitle: " Lancefield District Farmers Market ", newSubtitle: " Address: Centre Plantation, High St, Lancefield, Opening: 4th Saturday (3rd Sat. in Dec) 9am - 1pm ",
                                                              lat: 26.1451116,
                                                              long: -80.2408729))
            
            marketAnnotations.append(Market(newTitle: " Manningham Farmers Produce & Craft market ",
            newSubtitle: " Address: The Manningham Club, 1 Thompsons Rd, Bulleen, Opening: 4th Sunday 8am -1pm ",
            lat: -37.7772952,
            long: 145.0811754))
            
            marketAnnotations.append(Market(newTitle: " Mansfield Farmers Market ",
            newSubtitle: " Address: Mansfield Primary School, Highett Street, Mansfield, 4th Saturday (except January) 8am - 1pm ",
            lat: -37.055442,
            long: 146.085621))
            
            marketAnnotations.append(Market(newTitle: " Metung Farmers Markets ",
            newSubtitle: " Address: Village Green, cnr Kurnai Ave and Metung Rd, Metung, Opening: 2nd Saturday 8am - 12.30 pm ",
            lat: -37.8921998,
            long: 147.853599))
            
            marketAnnotations.append(Market(newTitle: " Mooroopna Farmers Market ",
            newSubtitle: " Address: Ferrari Park, Midland Hwy, Mooroopna, Opening: 3rd Sundays, 8.30am - 1pm ", lat: 36.3940748,
            long: 145.3509905))
            
            marketAnnotations.append(Market(newTitle: " Mornington Farmers Market ",
            newSubtitle: " Address: Mornington Park, Schnapper Point Drive, Mornington, Opening: 2nd Saturdays, 9am - 1pm ",
            lat: -38.2157199,
            long: 145.0355221))
            
            marketAnnotations.append(Market(newTitle: " Mount Eliza Farmers Market ",
            newSubtitle: " Address: cnr Mt Eliza Way + Canadian Bay Road, Mt Eliza, Opening: 4th Sunday 9am - 1pm ",
            lat: -38.1837402,
            long: 145.0892463))
            
            marketAnnotations.append(Market(newTitle: " Moyhu Farmers Market  ",
            newSubtitle: " Address: Lions Park, cnr Wangaratta - Whitfield and Meadow Creek Roads Moyhu Memorial Hall if wet, Moyhu, Opening: 3rd Saturday 8am - noon ",
            lat: -36.676733,
            long: 146.4191264))
            
            marketAnnotations.append(Market(newTitle: " Mulgrave Farmers Market ",
            newSubtitle: " Address: Corner Jacksons & Wellington Roads, Mulgrave, Opening: Every Sunday 8am - 1pm ",
            lat: -41.2864603,
            long: 174.776236))
            
            marketAnnotations.append(Market(newTitle: " Newtown Farmers Market ",
            newSubtitle: " Address: cnr Shannon Ave + West Fyans Road, Newtown, Opening: 4th Saturday 8am - 1pm ", lat: -38.1582278,
            long: 144.3330397))
            
            marketAnnotations.append(Market(newTitle: " North Essendon Farmers Market ", newSubtitle: " Address: Thompson Reserve, Keilor Road (between Collins & McCracken Sts), Essendon, Opening: 2nd Saturday 8am- 1pm ",
                                                         lat: -37.7783805,
                                                         long: 144.8916897))
            
            marketAnnotations.append(Market(newTitle: " Park Orchards Farmers Market ",
            newSubtitle: " Address: cnr Hopetoun + Park Roads, Park Orchards, Opening: 3rd Saturday 9am - 1pm ", lat: -37.7789818,
            long: 145.2175655))
            
            marketAnnotations.append(Market(newTitle: " Pearcedale Farmers Market  ",
            newSubtitle: " Address: Pearcedale Community Centre, 710 Baxter - Tooradin Rd, Pearcedale, Opening: 3rd Saturday 8am - 1 pm ",
            lat: -38.2028849,
            long: 145.2277941))
            
            marketAnnotations.append(Market(newTitle: " Port Fairy Farmers Market ",
            newSubtitle: " Address: Fiddlers Green, cnr Sackville and Bank Streets, Port Fairy, Opening: 3rd Saturday 8am - 1 pm ",
            lat: -38.38305829999999,
            long: 142.2329629))
            
            marketAnnotations.append(Market(newTitle: " Prom Country Farmers Market  ", newSubtitle: " Address: Foster War Memorial Arts Centre Hall, Main St, Foster, Opening: 3rd Saturday 8am - 12pm ",
                                                         lat: -38.6518186,
                                                         long: 146.2029932))
            
            marketAnnotations.append(Market(newTitle: " Riddells Creek Farmers Market  ", newSubtitle: " Address: Riddells Creek Primary School, Main Road, Riddells Creek, Opening: 3rd Saturday 9 am - 1 pm ",
                                                           lat: -37.461186,
                                                           long: 144.680612))
            
            marketAnnotations.append(Market(newTitle: " Seaford Farmers Market ",
            newSubtitle: " Address: Broughton Street Reserve, Station St, Seaford, Opening: 3rd Sunday, 8am - 1 pm ",
            lat: -38.1026221,
            long: 145.1266272))
            
            marketAnnotations.append(Market(newTitle: " Slow Food Melbourne Farmers Market  ", newSubtitle: " Address: Abbotsford Covent, St Heliers St, Abbotsford, Opening: 4th Saturday 8am - 1pm ", lat: -37.8025757,
                                                                long: 145.0044112))
            
            marketAnnotations.append(Market(newTitle: " Substation Farmers Market ",
            newSubtitle: " Address: The Substation, 1 Market Street, Newport, Opening: 1st & 3rd Sundays 9am - 1pm ",
            lat: -37.84417750000001,
            long: 144.8829436))
            
           marketAnnotations.append(Market( newTitle: " Sunraysia Farmers Market  ",
            newSubtitle: " Address: Ornamental Lakes, High King Drive, Mildura, Opening: First + Third Saturday monthly 8am - noon (Oct - Mar) 9am - noon (Apr - Sept) Check website for dates ",
            lat: -34.1850209,
            long: 142.1696649))
            
            marketAnnotations.append(Market(newTitle: " Talbot Farmers Market ",
            newSubtitle: " Address: Talbot Historic Precinct, Scandinavian Cres, Talbot, Opening: 3rd Sunday 9am - 1pm ",
            lat: -37.171664,
            long: 143.70226))
            
            marketAnnotations.append(Market(newTitle: " Tallarook Farmers Market ",
            newSubtitle: " Address: Tallarook Mechanic Institute, Main Road, Tallarook, Opening: 1st Sunday 8.30am - 1pm ",
            lat: -37.095496,
            long: 145.101772))
            
            marketAnnotations.append(Market(newTitle: " Tatong Village Market ",
            newSubtitle: " Address: Tatong Tavern Hotel, Tatong, Opening: 1st Saturday 8am - 1 pm ",
            lat: -36.730035,
            long: 146.1077868))
            
            marketAnnotations.append(Market(newTitle: " Traralgon Farmers Market ",
            newSubtitle: " Address: Kay Street Gardens, Kay St Opposite Council Chambers, Traralgon, Opening: 4th Saturday 8am - 1 pm ",
            lat: -38.19380510000001,
            long: 146.5346825))
            
            marketAnnotations.append(Market(newTitle: " Trentham Farmers Market  ",
            newSubtitle: " Address: Trentham Town Square, Victoria Street, Trentham, Opening: 3rd Saturday ",
            lat: -37.388865,
            long: 144.3216767))
            
            marketAnnotations.append(Market(newTitle: " Veg Out St Kilda Farmers Market  ", newSubtitle: " Address: Peanut Farm Reserve, cnr Shakespeare Grove &amp; Chaucer Streets, St Kilda, Opening: 1st Saturday 8:30am - 1:00pm ",
                                                             lat: 37.8684332,
                                                             long: 144.9780666))
            
            marketAnnotations.append(Market(newTitle: " Warragul Farmers Market ",
            newSubtitle: " Address: Civic Park, civic place, Warragul, Opening: 3rd Saturday, 8.30am -1pm ",
            lat: -38.1577014,
            long: 145.9341179))
            
            marketAnnotations.append(Market(newTitle: " Werribee Central Farmers Market ", newSubtitle: " Address: Kelly Park, Synnot Street, Werribee, Opening: 4th Saturday, 8am - 2pm ",
                                                           lat: -37.9006924,
                                                           long: 144.6645204))
            
            marketAnnotations.append(Market(newTitle: " Wheelers Hill Farmers Market ",
            newSubtitle: " Address: Jells Park South, Ferntree Gully Rd, Wheelers Hill, Opening: 3rd Saturday 8am - 1 pm ",
            lat: -37.8984525,
            long: 145.1996861))
            
            marketAnnotations.append(Market(newTitle: " Whitehorse Farmers Market  ",
            newSubtitle: " Whitehorse Civic Centre, 379 - 397 Whitehorse Rd, Nunawading, Opening: 2nd Sunday 8am -1 pm ",
            lat: -37.816219,
            long: 145.181682))
            
            marketAnnotations.append(Market(newTitle: " Williamstown Farmers Market  ", newSubtitle: " Address: Commonwealth Reserve, Nelsons Place, Williamstown, Opening: 2nd Sunday 9am - 1pm ",
                                                         lat: -37.8622422,
                                                         long: 144.903574))
            
            marketAnnotations.append(Market(newTitle: " Woodend Community Farmers Market  ", newSubtitle: " Address: Woodend, High Street, Woodend, Opening: First Saturday of each month, 9am - 1pm ",
                                                              lat: -37.3585193,
                                                              long: 144.5272844))
            
            marketAnnotations.append(Market(newTitle: " Yarram Variety Market ",
            newSubtitle: " Address:  Cnr Church St & Commercial Rd, Yarram, Opening: First Sunday every month 8am - 1pm ",
            lat: -38.5564043,
            long: 146.6776119))
            
            marketAnnotations.append(Market(newTitle: " Yarraville Farmers Market ",
            newSubtitle: " Address: Yarraville Gardens, cnr Hyde and Somerville Rds, Yarraville, Opening: 4th Saturday 9am -1pm winter, 8am - 12pm summer ",
            lat: -37.8138205,
            long: 144.8989117))
            
            marketAnnotations.append(Market(newTitle: " Yarrawonga Farmers Market ",
            newSubtitle: " Address: Piper Street, Yarrawonga, Opening: 4th Sunday 8am - 1pm ",
            lat: -36.0110563,
            long: 146.0059326))
        

    }
    
    
    
    
    

}



extension MarketViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Market else { return nil }
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        let locationLabel = UILabel() // create a popup label
        locationLabel.numberOfLines = 0
        locationLabel.font = locationLabel.font.withSize(13)
        locationLabel.text = (annotationView!.annotation as! Market).subtitle
        annotationView!.detailCalloutAccessoryView = locationLabel // use calloutaccessoryview to add the popup label
        annotationView?.image = UIImage(named: "shop")
      
       
    
        
        return annotationView
    }
    
  
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let location = view.annotation as? Market {
            self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
        }
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor.red
        
        renderer.lineWidth = 3.0
        
        return renderer
    }
    
}
