#' Makes data frame of top YouTube videos
#'
#' @param key Your YouTube API key
#' @param region Region. Default is "US". Run get_region_list() to see list of YouTube cntent regions.
#' @param category Video category. Default is 0 (no category, top videos overall). Run get_category_list() to see list of YouTube content categories.
#' @param n Number of results returned. Default is 10. Can be between 1 and 50.
#' @param simple Returns a simplified data frame if TRUE (default). Returns all data from API if FALSE.
#'
#' @return A data frame of the top trending videos on YouTube
#'
#'
#' @export
get_top_videos <- function(key, region = "US", category = 0, n = 10, simple = T){
  region_id <- ifelse(nchar(region) != 2, region_to_id(key, region), region)
  ## need to add in stop for non-returning categories
  category_id <- ifelse(nchar(region) > 2, category_to_id(key, category, region_id), category)
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/videos?part=statistics%2Csnippet&chart=mostPopular&regionCode=",
                    region_id,
                    "&videoCategoryId=",
                    category_id,
                    "&maxResults=",
                    n,
                    "&videoCategoryId=10&key=",
                    key))
  data <- fromJSON(rawToChar(res$content))
  videos <- data$items
  snip <- videos$snippet
  local <- snip$localized %>%
    rename(localizedTitle = title, localizedDescription = description)
  stats <- videos$statistics
  videos <- videos %>%
    select(-snippet, -statistics) %>%
    cbind(select(snip, -localized),
          local,
          stats) %>%
    mutate(publishedAt = as.POSIXct(trimws(gsub("[A-Z]", " ",publishedAt)), tz = "US/Pacific"),
           regionId = region_id) %>%
    left_join(get_category_list(region = region_id, key = key)) %>%
    left_join(get_region_list(key))
  simple_videos <- select(videos, id:description, channelTitle, tags, viewCount:commentCount, category:region)
  if (simple) {
    videos = simple_videos
  }
  return(videos)
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
#' @export
get_category_list <- function(key, region = "US"){
  region_id <- ifelse(nchar(region) != 2, region_to_id(key, region), region)
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/videoCategories?part=snippet&regionCode=", region_id, "&key=", key))
  data <- fromJSON(rawToChar(res$content))
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
#'
#'
#' @export
get_region_list <- function(key){
  res <- GET(paste0("https://www.googleapis.com/youtube/v3/i18nRegions?part=snippet&key=", key))
  data <- fromJSON(rawToChar(res$content))
  regions <- data$items$snippet %>%
    rename(region = name, regionId = gl)
  return(regions)
}

