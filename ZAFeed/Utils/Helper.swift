//
//  Helper.swift
//  ZAFeed
//
//  Created by tringuyen3297 on 26/03/2022.
//

import Foundation

struct K {
    static let api_access_token                     = "xR-y5euXNW0VwLY-cDCNfMoZTcPtU5VR4XR86xIKD1U"
    
    static let api_secret_key                       = "ssho4iGARmP0PKKoLRxofBt5M055-yQUY6MBcHOonjk"
    
    static let api_method_get                       = "GET"
    
    static let api_method_post                      = "POST"
    
    static let api_method_delete                    = "DELETE"
    
    static let api_unsplash_authorize               = "https://unsplash.com/oauth/authorize"
    
    static let api_unsplash_request_token           = "https://unsplash.com/oauth/token"
    
    static let api_unsplash_photos_url              = "https://api.unsplash.com/photos"
    
    static let api_unsplash_photos_like             = "https://api.unsplash.com/photos/%@/like"
    
    static let api_field_authorization              = "Authorization"
    
    static let api_unsplash_field_page              = "page"
    
    static let api_unsplash_grant_type              = "grant_type"
    
    static let api_unsplash_field_client_id         = "client_id"
    
    static let api_unsplash_field_client_secret     = "client_secret"
    
    static let api_unsplash_field_redirect_uri      = "redirect_uri"
    
    static let api_unsplash_field_response_type     = "response_type"
    
    static let api_unsplash_field_scope             = "scope"
    
    static let api_unsplash_field_code              = "code"
    
    static let api_unsplash_authorization_code      = "authorization_code"
    
    static let app_redirect_uri                     = "zafeed://unsplash"
    
    static let app_url_scheme                       = "zafeed"
    
    static let app_write_like_scope                 = "public+read_user+write_likes"
    
    static let app_screen_tittle                    = "Gallery"
    
    static let app_cell_name                        = "FeedTableViewCell"
    
    static let app_action_like                      = "Like"
    
    static let app_action_unlike                    = "Unlike"
    
    static let app_alert_title                      = "Alert"
    
    static let app_field_access_token               = "access_token"
    
    static let app_alert_msg_need_login_for_like    = "You need to login Unsplash first.\nDo you want to continue?"
    
    static let app_alert_msg_server_fail            = "Connect to server failed.\n Please try again later!"
}
