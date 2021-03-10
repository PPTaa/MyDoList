//
//  Storage.swift
//  MyDoList
//
//  Created by leejungchul on 2021/03/03.
//

import Foundation

public class Storage {
    private init(){}
    
    enum Directory {
        case documents, caches
        
        var url: URL {
            let path: FileManager.SearchPathDirectory
            switch self {
            case .documents:
                path = .documentDirectory
            case .caches:
                path = .cachesDirectory
            }
            return FileManager.default.urls(for: path, in: .userDomainMask).first!
        }
    }
    
//    static func store<T: Encodable>(_ obj: T, to directory: Directory, as fileName:String) {
//        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
//        print("save here ---> \(url)")
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//
//        do {
//            let data = try encoder.encode(obj)
//            if FileManager.default.fileExists(atPath: url.path) {
//                try FileManager.default.removeItem(at: url)
//            }
//            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
//        } catch let error {
//            print("error Occured in store : \(error.localizedDescription)")
//        }
//    }

    static func retrieve<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        print("retrieve here \(fileName)")
        let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }

        let decoder = JSONDecoder()

        do {
            let model = try decoder.decode(type, from: data)
            return model
        } catch let error {
            print("error Occured in retrieve : \(error.localizedDescription)")
            return nil
        }
    }
}

extension Storage {
    static func saveMydo(_ obj:[Mydo], fileName: String) {
        let url = Directory.documents.url.appendingPathComponent(fileName, isDirectory: false)
        print(" saveMydo save to here : \(url)")
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            //데이터를 인코딩
            let data = try encoder.encode(obj)
            //같은 데이터가 있는지 확인
            if FileManager.default.fileExists(atPath: url.path) {
                // 있다면 삭제
                try FileManager.default.removeItem(at: url)
            }
            //데이터를 파일 명으로 생성
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch let error {
            print("fail to storage : \(error.localizedDescription)")
        }
    }
    
    static func restoreMydo(_ fileName: String) -> [Mydo]? {
        //파일 이름 입력
        let url = Directory.documents.url.appendingPathComponent(fileName, isDirectory: false)
        print(" restore to here : \(url)")
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        //파일 이름을 데이터 형태로 읽어옴
        guard let data = FileManager.default.contents(atPath: url.path) else { return nil }
        
        //데이터 디코딩
        let decoder = JSONDecoder()
        
        do {
            //스트럭트 형태로 변환해서 가져옴
            let model = try decoder.decode(Mydo.self, from: data)
            print("read json : \(model)")
            return model
        } catch let error {
            print("fail to storage in restore: \(error.localizedDescription)")
            return nil
        }
    }
}
