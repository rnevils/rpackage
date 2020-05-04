#' Determines if user is providing a valid API key
#'
#' @param api_key The Youtube API key
#'
#' @return A status code of the API call
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export

valid_api_call <- function(api_key) {
  base <- "https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&maxResults=50&key="
  request <- paste0(base, api_key)
  res = GET(request)
  return(res$status_code)
}

#' Creates and returns a word cloud of 200 of the titles on YouTube's most popular videos
#'
#' @param api_key A user's API key
#' @param size The size of the title word cloud to be returned
#' @param color The color of the title word cloud to be returned
#' @param shape The shape fo the title word cloud to be returned
#'
#' @return A word cloud using 200 of the titles from YouTube's most popular videos
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom wordcloud2 wordcloud2
#' @export

make_top_title_word_cloud <- function(api_key, size, color, shape){
  top_titles <- get_top_titles(api_key)
  tidy_titles <- get_tidy_titles(top_titles)
  top_titles_wordcloud <- wordcloud2(data=tidy_titles, size=size, color=color, shape=shape)
  return(top_titles_wordcloud)
}

#' Returns a list of top YouTube videos
#'
#' @param api_key a user's API key
#'
#' @return A list of 200 titles from the most popular YouTube video pages
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export

get_top_titles <- function(api_key) {
  base_mostpopular_snippet <- "https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&maxResults=50&key="
  request_mostpopular_titles <- paste0(base_mostpopular_snippet, api_key)

  res = GET(request_mostpopular_titles)
  data <- fromJSON(rawToChar(res$content))

  titles <- data$items$snippet$title

  # needed when fetching results from next page
  base_with_nextpage <- "https://www.googleapis.com/youtube/v3/videos?part=snippet&chart=mostPopular&maxResults=50&pageToken="

  # since the GET() call can only return 100 comments at a time, need to call it multiple times, using the "pageToken" of the next page
  for(i in 1:3) {

    # get next page
    next_page <- data$nextPageToken

    # if there are no more pages of titles, break
    if (is.null(next_page)) {
      break
    }

    # combine to create the request string
    request <- paste0(base_with_nextpage, next_page, "&key=", api_key)

    # make the API call and get the data
    res = GET(request)
    data <- fromJSON(rawToChar(res$content))

    # get the titles from the next page
    new_titles <- data$items$snippet$title

    # append the new titles to the existing list of titles
    titles <- c(titles, new_titles)
  }

  return(titles)
}


#' Creates a list of cleaned list of YouTube video titles for word cloud and sentiment analysis
#'
#' @param titles list of YouTube videos titles to be cleaned
#'
#' @return A cleaned list of YouTube titles
#'
#' @importFrom dplyr anti_join
#' @importFrom tibble tibble
#' @importFrom tidytext unnest_tokens

get_tidy_titles <- function(titles) {
  tidy_titles <- titles %>%
  tibble(titles) %>%
  unnest_tokens(word, titles) %>% # break the titles into individual words
  anti_join(stop_words) # data provided by the tidytext package
  return(tidy_titles)
}

