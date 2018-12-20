//
//  Constants.swift
//  Value
//
//  Created by Omar Torres on 11/3/18.
//  Copyright © 2018 OmarTorres. All rights reserved.
//

import Foundation

let API_AUTH_NAME = "<YOUR_HEROKU_API_ADMIN_NAME>"
let API_AUTH_PASSWORD = "<YOUR_HEROKU_API_PASSWORD>"
let BASE_URL = "https://thawing-eyrie-63788.herokuapp.com/api"

// Defaults values and keys
let employeeDefaultsValue = "loggedIn"
let employeeDefaultsKey = "userLoggedIn"
let adminDefaultsValue = "AdminLoggedIn"
let adminDefaultsKey = "adminLoggedIn"

// Keychain values
let employeeKeychainAuthData = "authenticationToken"
let employeeKeychainAuthAccount = "AuthToken"
let employeeKeychainIdData = "id"
let employeeKeychainIdAccount = "currentUserId"
let employeeKeychainNameData = "name"
let employeeKeychainNameAccount = "currentUserName"
let employeeKeychainEmailData = "email"
let employeeKeychainEmailAccount = "currentUserEmail"
let employeeKeychainAvatarData = "avatar"
let employeeKeychainAvatarAccount = "currentUserAvatar"

let adminKeychainAuthData = "adminAuthenticationToken"
let adminKeychainAuthAccount = "AdminAuthToken"
let adminKeychainIdData = "id"
let adminKeychainIdAccount = "currentAdminId"
let adminKeychainNameData = "name"
let adminKeychainNameAccount = "currentAdminName"
let adminKeychainEmailData = "email"
let adminKeychainEmailAccount = "currentAdminEmail"
let adminKeychainAvatarData = "avatar"
let adminKeychainAvatarAccount = "currentAdminAvatar"

// Notifications name
let updateUserHeaderInfo = Notification.Name("UpdateUserHeaderInfo")
let updateUserProfileFeedNotificationName = Notification.Name("UpdateUserProfileFeedNotificationName")

// Fetch all reviews url
let GET_ALL_REVIEWS_URL = "\(BASE_URL)/all_reviews"

// Login/Signup urls
let SIGNIN_URL = "\(BASE_URL)/users/signin"
let SIGNUP_URL = "\(BASE_URL)/users/signup"

// Get all users url
let GET_ALL_USERS_URL = "\(BASE_URL)/all_users"








