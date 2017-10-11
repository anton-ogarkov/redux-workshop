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
import Core

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

        self.store.bind(worker: constructCountryUpdateAC())()

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
        return state.countries.map({ item in
            return (name: item.value.name, selected: {
                let statesProps = self.statesScreenProps(countryDTO: item.value)
                let statesViewController = self.createStatesViewController(props: statesProps)
                statesViewController.props = self.statesScreenProps(countryDTO: item.value)
                    
                self.store.bind(worker: constructStateUpdateAC(item.value.code3))()
                self.store.subscribe(subscriber: { storeState in
                    let states = storeState.countries[item.value.code3]?.states.flatMap({storeState.states[$0]}) ?? []
                    statesViewController.props = self.statesScreenProps(countryDTO: item.value, states: states)
                })
            
                self.navigationController?.pushViewController(statesViewController, animated: true)
            })
        }).sorted(by: {$0.name < $1.name})
    }
    
    private func statesScreenProps(countryDTO: CountryDTO, states: [StateDTO] = []) -> StatesViewController.Props {
        let stateProps = states.sorted(by: {$0.name < $1.name}).map { item -> StatesViewController.State in
            return (name: item.name, selected: {
                print("Selected state: \(item)")
            })
        }
        return (states: stateProps, countryName: countryDTO.name)
    }
    
}
