#' Generates a plot of the number of words that contribute to different sentiments in  the top
#' 200 YouTube titles using the NRC lexicon
#'
#' @param api_key A user's API key
#'
#' @return A plot of the number of words that contribute to different sentiments for the top 200 YouTube titles
#'
#' @importFrom dplyr inner_join group_by summarise ungroup mutate
#' @importFrom tidytext unnest_tokens get_stopwords get_sentiments
#' @importFrom dplyr anti_join
#' @importFrom ggplot2 scale_y_continuous guides
#'
#' @export

titles_sentiment_type_nrc <- function(api_key){
  top_titles <- get_top_titles(api_key)
  tidy_titles <- get_tidy_titles(top_titles)
  nrc_plot <- tidy_titles %>%
      inner_join(get_sentiments("nrc")) %>%
      group_by(sentiment) %>%
      summarise(word_count = n()) %>%
      ungroup() %>%
      mutate(sentiment = reorder(sentiment, word_count)) %>%
      #Use `fill = -word_count` to make the larger bars darker
      ggplot(aes(sentiment, word_count, fill = -word_count)) +
      geom_col() +
      guides(fill = FALSE) + #Turn off the legend
      theme_gray() +
      labs(x = NULL, y = "Word Count") +
      scale_y_continuous(limits = c(0, 100)) + #Hard code the axis limit
      ggtitle("YouTube Title Sentiment Analysis") +
      coord_flip()
    return(nrc_plot)
}

#' Generates a plot of top 10 words that contribute to positive and negative sentiment in the top
#' 200 YouTube titles using the Bing lexicon
#'
#' @param api_key A user's API key
#'
#' @return A plot of top 10 words that contribute to positive and negative sentiment in the top 200 YouTube titles
#'
#' @importFrom ggplot2 ggplot geom_bar geom_col labs coord_flip theme aes element_blank element_rect element_line coord_flip facet_wrap
#'
#' @export

titles_sentiment_contribution_bing <- function(api_key){
  top_titles <- get_top_titles(api_key)
  tidy_titles <- get_tidy_titles(top_titles)
  bing_word_counts <- tidy_titles  %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  ungroup()
  bing_plot <- bing_word_counts %>%
  group_by(sentiment) %>%
  top_n(10) %>%
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(y = "Contribution to sentiment of YouTube titles",
       x = NULL) +
  coord_flip()
  return(bing_plot)
}


