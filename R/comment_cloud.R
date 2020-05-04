#' Determine if user is providing a valid API key and video ID
#'
#' @param api_key The Youtube API key
#' @param video_id ID of youtube video
#'
#' @return A status code of the API call
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
valid_api_call_comment <- function(api_key, video_id) {
  base <- 'https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&maxResults=100&textFormat=plainText&videoId='
  request <- paste0(base, video_id, "&key=", api_key)
  res = GET(request)

  return(res$status_code)
}


#' Access the youtube API to get a list of comments from a video.
#'
#' @param api_key The Youtube API key
#' @param video_id ID of youtube video
#'
#' @return A list of comments
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_detect str_to_title
#' @importFrom english as.english
get_comments <- function(api_key, video_id) {
  stopifnot(valid_api_call_comment(api_key, video_id) == 200)



  base <- 'https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&maxResults=100&textFormat=plainText&videoId='
  request <- paste0(base, video_id, "&key=", api_key)
  res = GET(request)
  data <- fromJSON(rawToChar(res$content))
  comments <- data$items$snippet$topLevelComment$snippet$textDisplay

  # since the GET() call can only return 100 comments at a time, need to call it multiple times, using the "pageToken" of the next page
  base2 <- "https://www.googleapis.com/youtube/v3/commentThreads?part=snippet&maxResults=100&pageToken="

  for(i in 1:3) {
    # get next page
    next_page <- data$nextPageToken

    # if there are no more pages of comments, break
    if (is.null(next_page)) {
      break
    }

    # fix next page
    next_page <- gsub('.{1}$', '', next_page)

    # combine to create the request string
    request2 <- paste0(base2, next_page, "%3D&textFormat=plainText&videoId=", video_id, "&key=", api_key)

    # make the API call and get the data
    res = GET(request2)
    data <- fromJSON(rawToChar(res$content))

    # get the comments from the next page
    new_comments <- data$items$snippet$topLevelComment$snippet$textDisplay

    # append the new comments to the existing list of comments
    comments <- c(comments, new_comments)
  }

  return(comments)
}


#' Create a word cloud from a list of comments.
#'
#' @param api_key The Youtube API key
#' @param video_id ID of youtube video
#'
#' @return A word cloud
#'
#' @importFrom tibble tibble
#' @importFrom wordcloud wordcloud
#' @importFrom tidytext unnest_tokens get_stopwords
#' @importFrom dplyr anti_join count
#'
#' @export
make_cloud <- function(api_key, video_id) {
  comments <- get_comments(api_key, video_id)
  tibble(comments) %>%
    unnest_tokens(word, comments) %>%
    anti_join(get_stopwords(), by = "word") %>%
    count(word) %>%
    with(wordcloud(word, n, max.words = 100))
}

