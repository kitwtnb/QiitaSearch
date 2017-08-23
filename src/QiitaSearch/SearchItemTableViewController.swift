//
//  SearchItemTableViewController.swift
//  QiitaSearch
//

import UIKit

class SearchItemTableViewController: UITableViewController, UISearchBarDelegate {
    private var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Search bar delegte
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let inputText = searchBar.text else {
            return
        }
        
        guard 0 < inputText.lengthOfBytes(using: String.Encoding.utf8) else {
            return
        }
        
        items.removeAll()
        
        let url = createRequestUrl(query: inputText)
        request(requestUrl: url)
        
        searchBar.resignFirstResponder()
    }
    
    func createRequestUrl(query: String) -> String {
        return "http://qiita.com/api/v2/tags/\(query)/items"
    }
    
    func request(requestUrl: String) {
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                let alert = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let jsonArray = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray else {
                return
            }
            
            self.parseItems(jsonArray: jsonArray)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        task.resume()
    }
    
    func parseItems(jsonArray: NSArray) {
        for json in jsonArray {
            guard let json = json as? NSDictionary else {
                break
            }
            
            let title = json["title"] as! String
            let url = json["url"] as! String
            let item = Item(title: title, url: url)
            self.items.append(item)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.title.text = item.title
        cell.url = item.url

        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemTableViewCell {
            // todo
        }
    }
}
