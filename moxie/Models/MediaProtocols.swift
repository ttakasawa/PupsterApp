//
//import UIKit
//
//
//protocol ImagePick where Self:UIViewController {
//    func pickImage(_ sender: UIButton)
//    func openCamera()
//    func openGallary()
//}
//
//extension ImagePick: UIImagePickerControllerDelegate {
//    func pickImage(_ sender: UIButton)
//    {
//        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallary()
//        }))
//
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//
//        /*If you want work actionsheet on ipad
//         then you have to use popoverPresentationController to present the actionsheet,
//         otherwise app will crash on iPad */
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func openCamera()
//    {
//        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
//        {
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        else
//        {
//            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func openGallary()
//    {
//        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = true
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        var chosenImage: UIImage?
//
//        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
//            chosenImage = editedImage
//        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            chosenImage = originalImage
//        }
//
//        if let selectedImage = chosenImage {
//            self.profileIcon.setImage(selectedImage, for: .normal)
//            UserManager.shared.uploadImageToStorage(newProfile: selectedImage)
//        }
//
//        dismiss(animated:true, completion: nil) //5
//    }
//}
//
//
