//
//  ListPostsPresenter.swift
//  ShorterMethods
//
//  Created by Raymond Law on 1/11/16.
//  Copyright (c) 2016 Raymond Law. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListPostsPresenterInput
{
  func presentFetchFollowerPosts(response: ListPosts_FetchFollowerPosts_Response)
}

protocol ListPostsPresenterOutput: class
{
  func displayFetchFollowerPosts(viewModel: ListPosts_FetchFollowerPosts_ViewModel)
  func displayFetchFollowerPostsFetchError(viewModel: ListPosts_FetchFollowerPosts_ViewModel)
  func displayFetchFollowerPostsLoginError(viewModel: ListPosts_FetchFollowerPosts_ViewModel)
}

class ListPostsPresenter: ListPostsPresenterInput
{
  weak var output: ListPostsPresenterOutput!
  
  var dateFormatter: NSDateFormatter {
    let df = NSDateFormatter()
    df.dateStyle = .MediumStyle
    df.timeStyle = .MediumStyle
    return df
  }
  
  // MARK: Follower Posts
  
  func presentFetchFollowerPosts(response: ListPosts_FetchFollowerPosts_Response)
  {
    if let posts = response.posts {
      if !posts.isEmpty {
        handlePresentFetchFollowerPostsSuccess(response.posts!)
      }
    } else if let error = response.error {
      switch error {
      case .CannotFetch:
        handlePresentFetchFollowerPostsFailure(error)
      case .NotLoggedIn:
        handlePresentFetchFollowerPostsLoginError(error)
      }
    }
  }
  
  private func handlePresentFetchFollowerPostsSuccess(followerPosts: [Post])
  {
    let posts = formatFetchFollowerPosts(followerPosts)
    let viewModel = ListPosts_FetchFollowerPosts_ViewModel(posts: posts, error: nil)
    output.displayFetchFollowerPosts(viewModel)
  }
  
  private func handlePresentFetchFollowerPostsFailure(error: ListPosts_FetchFollowerPosts_Error)
  {
    let errorMsg = formatFetchFollowerPostsError(error)
    let viewModel = ListPosts_FetchFollowerPosts_ViewModel(posts: [], error: errorMsg)
    output.displayFetchFollowerPostsFetchError(viewModel)
  }
  
  private func handlePresentFetchFollowerPostsLoginError(error: ListPosts_FetchFollowerPosts_Error)
  {
    let errorMsg = formatFetchFollowerPostsError(error)
    let viewModel = ListPosts_FetchFollowerPosts_ViewModel(posts: [], error: errorMsg)
    output.displayFetchFollowerPostsLoginError(viewModel)
  }
  
  // MARK: Formatting
  
  private func formatFetchFollowerPosts(posts: [Post]?) -> [ListPosts_FetchFollowerPosts_ViewModel.Post]
  {
    var recentPosts: [ListPosts_FetchFollowerPosts_ViewModel.Post] = []
    if let posts = posts {
      for post in posts {
        let title = post.title
        let author = "\(post.user.firstName) \(post.user.lastName)"
        let publishedOn = dateFormatter.stringFromDate(post.timestamp)
        let recentPost = ListPosts_FetchFollowerPosts_ViewModel.Post(title: title, author: author, publishedOn: publishedOn)
        recentPosts.append(recentPost)
      }
    }
    return recentPosts
  }
  
  private func formatFetchFollowerPostsError(error: ListPosts_FetchFollowerPosts_Error?) -> String?
  {
    var errorMsg: String?
    if let error = error {
      switch error {
      case .CannotFetch(let msg):
        errorMsg = "ERROR: Cannot fetch - \(msg)"
      case .NotLoggedIn(let msg):
        errorMsg = "ERROR: Cannot login - \(msg)"
      }
    }
    return errorMsg
  }
}
