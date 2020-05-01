#' Creates and returns a word cloud of 50 of the titles on YouTube's most popular videos
#'
#' @param API_key A user's API key
#' @param size The size of the title word cloud to be returned
#' @param color The color of the title word cloud to be returned
#' @param shape The shape fo the title word cloud to be returned
#'
#' @return A word cloud using 200 of the titles from YouTube's most popular videos
#'
#'
#' @export

make_top_title_word_cloud <- function(api_key, size, color, shape){
  top_50 <- get_top_titles(api_key)
  top_50_cleaned <- clean_titles(top_50)
  top_50_formatted <- format_titles(top_50_cleaned)
  top_50_wordcloud <- wordcloud2(data=top_50_formatted, size=size, color=color, shape=shape)
  return(top_50_wordcloud)
}

#' Returns a list of top YouTube videos
#'
#' @param api_key a user's API key
#'
#' @return A list of 200 titles from the most popular YouTube video pages
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


#' Cleans a list of YouTube video titles
#'
#' @param A list of YouTube videos titles to be cleaned
#'
#' @return A cleaned list of YouTube titles

clean_titles <- function(titles) {
  titles_df <- Corpus(VectorSource(titles))
  tm_map(removeNumbers) %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace)
  clean_titles <- tm_map(titles, content_transformer(tolower))
  clean_titles <- tm_map(titles, removeWords, stopwords("english"))
  return(clean_titles)
}

#' Formats a list of YouTube video titles to be
#'
#' @param A list of YouTube videos titles to be formatted for a word cloud
#'
#' @return A formatted titles dataframe

format_titles <- function(clean_titles) {
  dtm <- TermDocumentMatrix(clean_titles)
  matrix <- as.matrix(dtm)
  words <- sort(rowSums(matrix),decreasing=TRUE)
  df <- data.frame(word = names(words),freq=words)
  return(df)
}

