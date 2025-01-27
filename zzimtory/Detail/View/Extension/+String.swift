//
//  +String.swift
//  zzimtory
//
//  Created by seohuibaek on 1/27/25.
//

extension String {
    // HTML 태그 제거
    var removingHTMLTags: String {
        return self.replacingOccurrences(of: "&lt;/?b&gt;", with: "", options: .regularExpression)
    }
}
