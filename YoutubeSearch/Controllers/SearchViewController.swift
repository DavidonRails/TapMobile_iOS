//
//  SearchViewController.swift
//  YoutubeSearch
//
//  Created by Admin on 2021/11/2.
//

import UIKit
import SwiftSoup

class SearchViewController: UIViewController {

    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var videos: [VideoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    

    func configureView() {
        txtSearch.delegate = self
    }
    
    func getResult(key: String) {
        ProgressHUD.shared.show(view: view, msg: "")
        APIService.shared.search(key: key, completion: {
            error, res, code in
            self.videos = []
            ProgressHUD.shared.dismiss()
            if error != nil {
                self.showAlert(title: "Error", msg: error!.localizedDescription)
            } else {
                let response = res as! String
                do {
                    let doc: Document = try SwiftSoup.parseBodyFragment(response)
                    let body: Elements = try doc.body()!.select("script")
                    for item in body.array() {
                        let content = try item.html()
                        if content.contains("var ytInitialData") {
                            let str = content.replacingOccurrences(of: "var ytInitialData = ", with: "", options: .literal, range: nil)
                            let jsonStr = str.dropLast()
                            let jsonData = self.convertStringToDictionary(text: String(jsonStr))
                            let contents = jsonData!["contents"] as! [String: Any]
                            let twoColumnSearchResultsRenderer = contents["twoColumnSearchResultsRenderer"] as! [String: Any]
                            let primaryContents = twoColumnSearchResultsRenderer["primaryContents"] as! [String: Any]
                            let sectionListRenderer = primaryContents["sectionListRenderer"] as! [String: Any]
                            let subContents = sectionListRenderer["contents"] as! [Any]
                            for cnt in subContents {
                                let cntItem = cnt as! [String: Any]
                                let itemSectionRenderer = cntItem["itemSectionRenderer"] as? [String: Any]
                                if itemSectionRenderer != nil {
                                    let cts = itemSectionRenderer!["contents"] as! [Any]
                                    for c in cts {
                                        let cc = c as! [String: Any]
                                        let vr = cc["videoRenderer"] as? [String: Any]
                                        if vr == nil {
                                            continue
                                        }
                                        
                                        let videoRenderer = cc["videoRenderer"] as! [String: Any]
                                        
                                        let videoID = videoRenderer["videoId"] as! String
                                        let thumbnail = videoRenderer["thumbnail"] as! [String: Any]
                                        let thumbnails = thumbnail["thumbnails"] as! [Any]
                                        let th = thumbnails.last as! [String: Any]
                                        let thumbURL = th["url"] as! String
                                        let title = videoRenderer["title"] as! [String: Any]
                                        let runs = title["runs"] as! [Any]
                                        let run = runs.first as! [String: Any]
                                        let titleStr = run["text"] as! String
                                        let lengthText = videoRenderer["lengthText"] as! [String: Any]
                                        let length = lengthText["simpleText"] as! String
                                        let viewCountText = videoRenderer["viewCountText"] as! [String: Any]
                                        let views = viewCountText["simpleText"] as! String
                                        
                                        let video = VideoModel(id: videoID, title: titleStr, thumbURL: thumbURL, length: length, views: views)
                                        self.videos.append(video)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                } catch Exception.Error(let _, let message) {
                    self.showAlert(title: "Error", msg: message)
                } catch {
                    self.showAlert(title: "Error", msg: error.localizedDescription)
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        let key = searchBar.text ?? ""
        if key.count > 0 {
            getResult(key: key)
        }
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate {
    
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell", for: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        
        let htmlStr = "<iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/\(video.id)\"></iframe>"
        cell.webView.loadHTMLString(htmlStr, baseURL: nil)
        return cell
    }
}
