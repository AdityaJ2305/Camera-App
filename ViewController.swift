import UIKit
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // IB - Interface Builder
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    
    private func isCameraAvailable() -> Bool {
        print(UIImagePickerController.isSourceTypeAvailable(.camera))
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryButton.isEnabled = false
//        imageView.layer.cornerRadius = 40
        guard isCameraAvailable() else {
            showAlert(title: "Error", message: "Camera is not available on this device.")
            captureButton.isEnabled = false
            return
        }
    }
    
    
    @IBAction func didTapedCaptureButton() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func didTapedGalleryButton() {
        guard let image = imageView.image else {
            showAlert(title: "Error", message: "No image to save.")
            return
        }
        print("in gallery func")
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "Image saved to your gallery.")
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", message: "Gallery access denied. Please enable it in settings.")
                }
            default:
                break
            }
        }
        imageView.image = nil
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let capturedImage = info[.originalImage] as? UIImage {
            imageView.image = capturedImage
            galleryButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
