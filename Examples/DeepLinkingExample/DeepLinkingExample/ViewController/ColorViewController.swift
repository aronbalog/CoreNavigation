import UIKit
import CoreNavigation
import ChromaColorPicker

class ColorViewController: UIViewController {
    lazy var colorPicker: ChromaColorPicker = {
        let view = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.padding = 5
        view.stroke = 3
        view.hexLabel.textColor = UIColor.black
        view.delegate = self
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(colorPicker)
        
        colorPicker.center = view.center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        colorPicker.adjustToColor(view.backgroundColor ?? .black)
    }
}

// MARK: DataReceivable
extension ColorViewController: DataReceivable {
    typealias DataType = UIColor

    func didReceiveData(_ data: UIColor) {
        view.backgroundColor = data
    }
}

// MARK: ChromaColorPickerDelegate
extension ColorViewController: ChromaColorPickerDelegate {
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        let alertController = UIAlertController(title: nil, message: "Open as:", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let viewControllerAction = UIAlertAction(title: "View controller", style: .default, handler: { (_) in
            Navigate.push { $0
                .to(Color())
                .passData(color)
            }
        })
        let urlAction = UIAlertAction(title: "URL", style: .default, handler: { (_) in
            let urlString = "https://demo7377577.mockable.io/color/" + color.hexCode
            
            let url = URL(string: urlString)!
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alertController.addAction(viewControllerAction)
        alertController.addAction(urlAction)
        alertController.addAction(closeAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
