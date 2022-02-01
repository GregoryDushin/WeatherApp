
import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
       
        
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    }

    @IBAction func locationButton(_ sender: UIButton) {
        
        locationManager.requestLocation()
    }
    
    
    
}
//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextField.endEditing(true) //убираем клавиатуру при нажатии кнопки/return
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        //action when the return button got pressed
        
        searchTextField.endEditing(true)  //убираем клавиатуру при нажатии кнопки/return

        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        //если нажать return/кнопка, а поле пустое ...
        
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //в этот момент используем searchTextField.text для определения погоды
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
            
            weatherManager.performRequest(city)
        }
        
        //затем удаляем текст из поля при нажатии кнопки/return
        searchTextField.text = ""
       
    }
}
//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
   
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        DispatchQueue.main.async {
    
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
          
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}







