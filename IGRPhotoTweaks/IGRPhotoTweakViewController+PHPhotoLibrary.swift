//
//  IGRPhotoTweakViewController+PHPhotoLibrary.swift
//  Pods
//
//  Created by Vitalii Parovishnyk on 4/26/17.
//
//

import Foundation
import Photos

extension IGRPhotoTweakViewController
{
    internal func saveToLibrary(image: UIImage)
    {
        let writePhotoToLibraryBlock: (() -> Void)? =
        {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
        {
            if let writePhoto = writePhotoToLibraryBlock
            {
                writePhoto()
            }
            
        }
        else
        {
            PHPhotoLibrary.requestAuthorization()
            { status  in
                if status == PHAuthorizationStatus.authorized
                {
                    DispatchQueue.main.async
                    {
                        if let writePhoto = writePhotoToLibraryBlock
                        {
                            writePhoto()
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async
                    {
                        let ac = UIAlertController(title: "Authorization error", message: "The app has not granted to access to the Photo Library", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        ac.addAction(UIAlertAction(title: "Settings", style: .default)
                        { _ in
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) else { return }
                            if #available(iOS 10.0, *)
                            {
                                UIApplication.shared.open(settingsUrl)
                            }
                            else
                            {
                                UIApplication.shared.openURL(settingsUrl)
                            }
                        })
                        self.present(ac, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        if let error = error
        {
            ac.title = "Save error"
            ac.message = error.localizedDescription
        }
        else
        {
            ac.title = "Saved!"
            ac.message = "Your image has been saved to your photos."
        }
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
