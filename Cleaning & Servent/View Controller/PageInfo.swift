/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct PageInfo : Codable {
	let from : Int?
	let per_page : Int?
	let to : Int?
	let total : Int?
	let next_page_url : String?
	let current_page : Int?
	let last_page : Int?
	let path : String?
	let prev_page_url : String?

	enum CodingKeys: String, CodingKey {

		case from = "from"
		case per_page = "per_page"
		case to = "to"
		case total = "total"
		case next_page_url = "next_page_url"
		case current_page = "current_page"
		case last_page = "last_page"
		case path = "path"
		case prev_page_url = "prev_page_url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		from = try values.decodeIfPresent(Int.self, forKey: .from)
		per_page = try values.decodeIfPresent(Int.self, forKey: .per_page)
		to = try values.decodeIfPresent(Int.self, forKey: .to)
		total = try values.decodeIfPresent(Int.self, forKey: .total)
		next_page_url = try values.decodeIfPresent(String.self, forKey: .next_page_url)
		current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
		last_page = try values.decodeIfPresent(Int.self, forKey: .last_page)
		path = try values.decodeIfPresent(String.self, forKey: .path)
		prev_page_url = try values.decodeIfPresent(String.self, forKey: .prev_page_url)
	}
    static func parsePageInfo(_ dictionary : [String: Any]?) -> PageInfo?{
        guard let dictionary = dictionary else{
            print("Nil Dictionary for Pagination")
            return nil
        }
        if dictionary.keys.count == 0 {
            return nil
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            do {
                let apiResponse = try JSONDecoder().decode(PageInfo.self, from: jsonData)
                return apiResponse
            }
            catch let error {
                print("Decoding Error :\(error)")
                return nil
            }
        }
        catch let error {
            print("Converting To Data :\(error)")
            return nil
        }
        
        
    }
    

}
