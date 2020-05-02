#' Creates a bar graphs of the most currently popular YouTube Videos by content category
#'
#' @param key Your YouTube API key
#' @param region Region. Default is "US". Run get_region_list() to see list of YouTube cntent regions.
#' @param n Number of top videos to graph. Default is 10. Can be between 1 and 200.
#'
#' @return A bar graph of the most currently popular YouTube Videos by content category
#'
#' @importFrom ggplot2 ggplot geom_bar labs coord_flip theme aes element_blank element_rect element_line
#'
#' @export
graph_top_videos_category <- function(key, region = "US", n = "10"){
  videos <- get_top_videos(key, region = region, n = n)
  graph <- ggplot(videos, aes(x = category, fill = category)) +
    geom_bar(stat = "count") +
    labs(x = "",
         y = "",
         title = paste("Most Popular YouTube Videos in", region, "by Content Category")) +
    coord_flip() +
    theme(legend.position = "none",
          panel.grid.major = element_blank(),
          panel.background = element_rect(fill = "white"),
          panel.grid.major.x = element_line(color = "lightgrey"))
  return(graph)
}


#' Makes data frame of most currently popular YouTube videos
#'
#' @param key Your YouTube API key
#' @param region Region. Default is "US". Run get_region_list() to see list of YouTube cntent regions.
#' @param category Video category. Default is 0 (no category, top videos overall). Run get_category_list() to see list of YouTube content categories.
#' @param n Number of top videos to return. Default is 10. Can be between 1 and 200.
#' @param simple Returns a simplified data frame if TRUE (default). Returns all data from API if FALSE.
#'
#' @return A data frame of the most currently popular videos on YouTube
#'
#' @importFrom dplyr select mutate left_join
#'
#' @export
get_top_videos <- function(key, region = "US", category = 0, n = 10, simple = T){
  if (n > 200) {
    stop("n must be between 1 and 200")
  }
  if (validate_region(key, region) == "invalid"){
    stop("Invalid region. See get_region_list() for list of acceptable regions.")
  }
  region_id <- ifelse(nchar(region) != 2, region_to_id(key, region), region)
  if (validate_category(key, region_id, category) == "invalid"){
    stop("Invalid category. See get_category_list() for list of acceptable categories.")
  }
  max_n <- ifelse(n > 50, 50, n)
  category_id <- ifelse(nchar(category) > 2, category_to_id(key, category, region_id), category)
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/videos?part=statistics%2Csnippet&chart=mostPopular&regionCode=",
                    region_id,
                    "&videoCategoryId=",
                    category_id,
                    "&maxResults=",
                    max_n,
                    "&videoCategoryId=10&key=",
                    key))
  data <- fromJSON(rawToChar(res$content))
  if (is.null(data$error$code) == F){
    stop(data$error$message)
  }
  if (data$pageInfo$totalResults == 0){
    stop("No results avaliable for this search")
  }
  next_page <- data$nextPageToken
  videos <- data$items %>%
    clean_top_videos() %>%
    mutate(publishedAt = as.POSIXct(trimws(gsub("[A-Z]", " ", publishedAt)), tz = "US/Pacific"),
           regionId = region_id) %>%
    left_join(get_category_list(region = region_id, key = key)) %>%
    left_join(get_region_list(key))
  if (n > 50){
    for (i in 1:3){
      res_next <-  res <- GET(paste0("https://www.googleapis.com/youtube/v3/videos?part=statistics%2Csnippet&chart=mostPopular&regionCode=",
                                     region_id,
                                     "&videoCategoryId=",
                                     category_id,
                                     "&maxResults=",
                                     max_n,
                                     "&pageToken=",
                                     next_page,
                                     "&videoCategoryId=10&key=",
                                     key))
      data_next <- fromJSON(rawToChar(res_next$content))
      videos_next <- data_next$items %>%
        clean_top_videos() %>%
        mutate(publishedAt = as.POSIXct(trimws(gsub("[A-Z]", " ",publishedAt)), tz = "US/Pacific"),
               regionId = region_id) %>%
        left_join(get_category_list(region = region_id, key = key)) %>%
        left_join(get_region_list(key))
      videos <- rbind(videos, videos_next)
    }
  }
  videos <- videos[1:n,]
  simple_videos <- select(videos, id:description, channelTitle, tags, viewCount:commentCount, category:region)
  if (simple) {
    videos = simple_videos
  }
  return(videos)
}


#' Validates region inputted by user
#'
#' @param key Your YouTube API key
#' @param region String or numeric value inputted by user
#'
#' @return String indicating if region given is valid or invalid
validate_region <- function(key, region){
  regions <- get_region_list(key)
  region_vec <- c(regions$regionId, regions$region)
  result <- ifelse(region %in% region_vec, "valid", "invalid")
  return(result)
}


#' Validates category inputted by user
#'
#' @param key Your YouTube API key
#' @param region YouTube content region
#' @param category String or numeric value inputted by user
#'
#' @return String indicating if region given is valid or invalid
validate_category <- function(key, region, category){
  categories <- get_category_list(key, region)
  cat_vector <- c(categories$categoryId, categories$category)
  result <- ifelse(category %in% cat_vector | category == 0, "valid", "invalid")
  return(result)
}


#' Cleans top vidoes data after scraping
#'
#' @param data Nested data table pulled from YouTube API
#'
#' @importFrom dplyr rename select
#'
#' @return A clean data frame of the top YouTube videos
clean_top_videos <- function(data){
  snip <- data$snippet
  local <- snip$localized %>%
    rename(localizedTitle = title, localizedDescription = description)
  thumb <- snip$thumbnails
  def <- thumb$default %>%
    rename(default_url = url, default_width = width, defualt_height = height)
  med <- thumb$medium %>%
    rename(medium_url = url, medium_width = width, medium_height = height)
  high <- thumb$high %>%
    rename(high_url = url, high_width = width, high_height = height)
  stan <- thumb$standard %>%
    rename(standard_url = url, standard_width = width, standard_height = height)
  max <- thumb$maxres %>%
    rename(maxres_url = url, maxres_width = width, maxres_height = height)
  stats <- data$statistics
  data <- data %>%
    select(-snippet, -statistics) %>%
    cbind(select(snip, -localized, -thumbnails),
          local,
          def,
          med,
          high,
          stan,
          max,
          stats)
  return(data)
}


#' Converts content category to YouTube id
#'
#' @param region String containing content category of intrest.
#'
#' @return A string of a single category id
category_to_id <- function(key, category, region = "US"){
  cats <- get_category_list(key = key, region = region)
  cat_id <- cats$categoryId[cats$category == category]
  return(cat_id)
}


#' Gets list of YouTube content categories
#'
#' @param region Region. Default is "US". Run get_region_list() to see list of YouTube regions
#' @param key Your YouTube API key
#'
#' @return A data frame of YouTube content categories and their ids
#'
#' @importFrom dplyr rename select
#'
#' @export
get_category_list <- function(key, region = "US"){
  if (validate_region(key, region) == "invalid"){
    stop("Invalid region. See get_region_list() for list of acceptable regions.")
  }
  region_id <- ifelse(nchar(region) != 2, region_to_id(key, region), region)
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&regionCode=", region_id, "&key=", key))
  data <- fromJSON(rawToChar(res$content))
  if(is.null(data$error$errors$reason) == F){
    if(data$error$errors$reason == "keyInvalid"){
      stop("API key is invalid")
    }
  }
  cats <- data$items
  snip <- cats$snippet
  cats <- cats %>%
    select(id) %>%
    cbind(select(snip, title)) %>%
    rename(category = title, categoryId = id)
  return(cats)
}


#' Converts region to YouTube id
#'
#' @param region String containing region of intrest.
#'
#' @return A string of a single region id
region_to_id <- function(key, region){
  regions <- get_region_list(key = key)
  region_id <- regions$regionId[regions$region == region]
  return(region_id)
}

#' Gets list of YouTube content regions
#'
#' @param key Your YouTube API key
#'
#' @return A data frame of YouTube regions and their ids
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr rename
#'
#' @export
get_region_list <- function(key){
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/i18nRegions?part=snippet&key=", key))
  data <- fromJSON(rawToChar(res$content))
  if(is.null(data$error$errors$reason) == F){
    if(data$error$errors$reason == "keyInvalid"){
      stop("API key is invalid")
    }
  }
  regions <- data$items$snippet %>%
    rename(region = name, regionId = gl)
  return(regions)
}

