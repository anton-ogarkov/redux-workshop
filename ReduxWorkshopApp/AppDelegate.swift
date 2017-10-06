//
//  AppDelegate.swift
//  ReduxWorkshopApp
//
//  Created by Anton Ogarkov on 10/4/17.
//  Copyright © 2017 private. All rights reserved.
//

import UIKit
import UI
import Business

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "private.UI"))
    
    let store = Store()
    
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let countriesViewController = self.createCountriesViewController(countries: self.countriesScreenProps(state: self.store.state))
        self.store.subscribe { (store) in
            countriesViewController.countries = self.countriesScreenProps(state: store)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.navigationController = UINavigationController(rootViewController: countriesViewController)
        self.window?.rootViewController = self.navigationController
        self.window?.makeKeyAndVisible()

        self.store.bind(worker: constructCountryUpdateWorker())()

        return true
    }
}

extension AppDelegate {
    private func createCountriesViewController(countries: [CountriesViewController.Country]) -> CountriesViewController {
        let countriesViewController: CountriesViewController = self.mainStoryboard.instantiateViewController(withIdentifier: "CountriesViewController") as! CountriesViewController
        countriesViewController.countries = countries
        
        return countriesViewController
    }
    
    private func createStatesViewController(props:StatesViewController.Props) -> StatesViewController {
        let statesViewController: StatesViewController = self.mainStoryboard.instantiateViewController(withIdentifier: "StatesViewController") as! StatesViewController
        statesViewController.props = props
        
        return statesViewController
    }
}

extension AppDelegate {
    
    private func countriesScreenProps(state: StoreState) -> [CountriesViewController.Country] {
        return state.countries.map({ countryDTO in
            return (name: countryDTO.name, selected:{
                let statesProps = self.statesScreenProps(countryName: countryDTO.name)
                let statesViewController = self.createStatesViewController(props: statesProps)
                self.navigationController?.pushViewController(statesViewController, animated: true)
            })
        })
    }
    
    private func statesScreenProps(countryName: String) -> StatesViewController.Props {
        let statesNames = ["Florida", "Washington DC"]
        let states = statesNames.map({ (stateName) -> StatesViewController.State in
            return (name: stateName, selected: {
                print("Selected state: \(stateName)")
            })
        })
        
        return (states: states, countryName: countryName)
    }
    
}
