//
//  FileManagerExtension.swift
//  Utility
//
//  Created by Sumeet Bajaj on 05/07/2018.
//

import Foundation

// Directory Name Constants

public extension FileManager {
    
    enum ActionType { case move, copy }
    enum ConflictResolution { case keepSource, keepDestination }
    
    var documentsDirectory: URL {
        return self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func isDir(atPath: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = self.fileExists(atPath: atPath, isDirectory: &isDir)
        return exist && isDir.boolValue
    }
    
    func isFile(atPath: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = self.fileExists(atPath: atPath, isDirectory: &isDir)
        return exist && !isDir.boolValue
    }
    
    func isDirEmpty(atPath: String) -> Bool {
        do {
            return try self.contentsOfDirectory(atPath: atPath).count == 0
        }
        catch _ {
            return false
        }
    }
    
    func merge(atPath: String, toPath: String, actionType: ActionType = .move, conflictResolution: ConflictResolution = .keepDestination, deleteEmptyFolders: Bool = false) {
        
        let pathEnumerator = self.enumerator(atPath: atPath)
        
        var folders: [String] = [atPath]
        
        while let relativePath = pathEnumerator?.nextObject() as? String {
            
            let subItemAtPath = URL(fileURLWithPath: atPath).appendingPathComponent(relativePath).path
            let subItemToPath = URL(fileURLWithPath: toPath).appendingPathComponent(relativePath).path
            
            if isDir(atPath: subItemAtPath) {
                
                if deleteEmptyFolders {
                    folders.append(subItemAtPath)
                }
                
                if !isDir(atPath: subItemToPath) {
                    do {
                        try self.createDirectory(atPath: subItemToPath, withIntermediateDirectories: true, attributes: nil)
                        Logger.debug("FoldersMerger: directory created: \(subItemToPath)")
                    }
                    catch let error {
                        Logger.debug("ERROR FoldersMerger: \(error.localizedDescription)")
                    }
                }
                else {
                    Logger.debug("FoldersMerger: directory \(subItemToPath) already exists")
                }
            }
            else {
                
                if isFile(atPath:subItemToPath) && conflictResolution == .keepSource {
                    do {
                        try self.removeItem(atPath: subItemToPath)
                        Logger.debug("FoldersMerger: file deleted: \(subItemToPath)")
                    }
                    catch let error {
                        Logger.debug("ERROR FoldersMerger: \(error.localizedDescription)")
                    }
                }
                
                do {
                    try self.moveItem(atPath: subItemAtPath, toPath: subItemToPath)
                    Logger.debug("FoldersMerger: file moved from \(subItemAtPath) to \(subItemToPath)")
                }
                catch let error {
                    Logger.debug("ERROR FoldersMerger: \(error.localizedDescription)")
                }
            }
        }
        
        if deleteEmptyFolders {
            folders.sort(by: { (path1, path2) -> Bool in
                return path1.components(separatedBy: "/").count < path2.components(separatedBy: "/").count
            })
            while let folderPath = folders.popLast() {
                if isDirEmpty(atPath: folderPath) {
                    do {
                        try self.removeItem(atPath: folderPath)
                        Logger.debug("FoldersMerger: empty dir deleted: \(folderPath)")
                    }
                    catch {
                        Logger.debug("ERROR FoldersMerger: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func sizeOfItemInBytes(forPath path:String, completion:@escaping ((Int64) -> Void)) {
        
        let queue = DispatchQueue(label: "ItemSizeCalculationQueue", qos: .background)

        queue.async {

            do {
                var total:Int64 = 0
                
                let attributes = try self.attributesOfItem(atPath: path)

                if  let fileTye = attributes[FileAttributeKey.type] as? FileAttributeType, fileTye == .typeRegular  {
                    total = attributes[FileAttributeKey.size] as? Int64 ?? 0
                }
                else {

                    if let dirEnum = FileManager.default.enumerator(at: URL(fileURLWithPath: path), includingPropertiesForKeys: [.fileSizeKey], options: [.skipsHiddenFiles], errorHandler: nil)  {
                        
                        for object in dirEnum {
                            
                            if let fileURL = object as? URL {
                                do {
                                    let fileSizeResource = try fileURL.resourceValues(forKeys: [.fileSizeKey])
                                    total += Int64(fileSizeResource.fileSize ?? 0)
                                }
                                catch {
                                    Logger.debug(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            
                completion(total)
            } catch {
                completion(0)
                Logger.debug(error.localizedDescription)
            }
        }
    }
}
