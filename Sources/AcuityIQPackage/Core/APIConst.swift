//
//  APIConst.swift
//  OJT_Package
//
//  Created by Kashif Hussain on 13/01/26.
//



import Foundation

internal struct APIConst {
    
    static let courseBaseUrl = "/api";
    static let versionAPI = "v1";
    static let lxpPath = "/org-content"
    static nonisolated(unsafe) var baseURL = ""
    static nonisolated(unsafe) var lxpOPath = ""
    static nonisolated(unsafe) var lxpBlobPath = ""
    static nonisolated(unsafe) var lxpBlobPath1 = ""
    static let ContentPath = "https://content.gogetempowered.com"
    static let GetScenariosForUser = "c/AIScenario/GetScenariosForUser/false"
    static let GetScenarioAnalysis = "c/AIScenario/GetAnalysis"
    static let GetScenarioOverallReport = "c/AIScenario/GetOverallReport"
    static let GetScenarioLeaderboard = "c/AIScenario/GetLeaderboard"
    static let PostFileUpload = "MediaLibrary/PostFileUpload"
    
    //AI API
    static let AI_Base_Url = "https://ailmsdev.gogetempowered.com"
    static let videoProctoring = "video_proctoring"
    static let evaluateVideoParameter = "evaluate_video_parameters"
   
}
