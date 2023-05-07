//
//  YetAnotherWeatherAppTests.swift
//  YetAnotherWeatherAppTests
//
//  Created by Kautilya Save on 5/7/23.
//

import XCTest
import Combine

@testable import YetAnotherWeatherApp


final class YetAnotherWeatherAppTests: XCTestCase {

    var viewModel: WeatherDetailViewModel?
    
    @MainActor override func setUpWithError() throws {
        viewModel = WeatherDetailViewModel(weatherService: WeatherManager.shared)
    }


    func test_whenEnteredCity_thenReturnsCityFullName() async throws {
        let testResult = await viewModel?.getWeatherCityby(name: "Denver")
        XCTAssertNotNil(testResult)
        XCTAssertEqual(testResult?.name, "Denver")
    }
    
    func test_whenEnteredWrongCity_thenReturnsNoCityName() async throws {
        let testResult = await viewModel?.getWeatherCityby(name: "Denver2")
        XCTAssertNil(testResult)
    }
    
    
    func test_whenRequestingMultipleCities_thenReturnsMultipleCitiesCount() async throws {
        
        let testResult = await viewModel?.testWeatherAPIByCity()
        XCTAssertNotNil(testResult)
        XCTAssertEqual(testResult?.count, 3)
    }
    
    
    func test_whenRequestingMultipleCities_thenReturnsMultipleCities() async throws {
        
        let testResult = await viewModel?.testWeatherAPIByCity()
        let expectedResult = ["Konkan Division", "London", "Hyderabad"]

        let anotherTestResult = testResult?.map{ String($0?.name ?? "") }
        XCTAssertEqual(anotherTestResult!, expectedResult)
    }
    
    
    
    func test_whenRequestingLocationViaLatLon_thenReturnLatLonCity() async throws {
        
        let lat = 37.7873589
        let lon = -122.408227
        
        let weatherCity = await viewModel?.weatherService.getCurrentWeather(latitude: lat, longitude: lon)
        XCTAssertEqual(weatherCity?.name, "San Francisco")
        XCTAssertEqual(weatherCity?.coord.lat.rounded(), lat.rounded())
        XCTAssertEqual(weatherCity?.coord.lon.rounded(), lon.rounded())

    }
    
    // Rather skip this Core location unit testing
    func test_whenRequestingLocationViaCoreLocation_thenReturnCity() async throws {
        // import CoreLocation
        // await CLLocationManager.authorizationStatus()
        await viewModel?.locationManager.requestLocation()
        let expectation = expectation(description: "Returned Location city")
        let expectedResult = "San Francisco"
        var cancellable = Set<AnyCancellable>()
        
        await viewModel?
            .$weatherVM
            .sink(receiveValue: { city in
                print("VAlue returned")
                if let city = city?.city.name {
                    print(city)
                    print("PASSSEDDDDD")
                    XCTAssertEqual(expectedResult, city)
                    expectation.fulfill()
                }
            })
            .store(in: &cancellable)

        
        // Old
//        wait(for: [expectation], timeout: 5)
        await fulfillment(of: [expectation], timeout: 5)

    }
    

}
