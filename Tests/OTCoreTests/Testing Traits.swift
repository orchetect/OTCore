//
//  Testing Traits.swift
//  OTCore
//
//  Created by Steffan Andrews on 2025-10-06.
//

// See: https://docs.github.com/en/actions/reference/workflows-and-actions/variables
// "GITHUB_ACTIONS"

func isRunningOnGitHubActions() -> Bool {
    #if GITHUB_ACTIONS
    return true
    #else
    return false
    #endif
}
