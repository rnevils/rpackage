
<!-- README.md is generated from README.Rmd. Please edit that file -->

# youRtube

<!-- badges: start -->

<!-- badges: end -->

The goal of youRtube is to easily gather data and create visualizations
from YouTube API data.

## Installation

You can install the the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("rnevils/youRtube")
```

``` r
library(youRtube)
```

## Getting Started

To use this package you need a YouTube API key. See
[here](https://developers.google.com/youtube/v3/getting-started) for how
to get a key.

Save your API key as a string called “key” for easy use with the
functions in the package

``` r
key <- "AIzaSyBAbuMv8NG47mox9ebPv9QWsuY9j3k2Ojd"
```

## Most Popular Videos Data

Use the function `get_top_videos` to create a data frame of the current
top trending videos on YouTube. You can specify which region and content
category you are interested in.

Overall top trending videos in the US

``` r
top50_us <- get_top_videos(key, n = 50)
```

Top trending music videos in Great
Britian

``` r
top10_uk_music <- get_top_videos(key, region = "United Kingdom", category = "Music")
```

Use `get_region_list()` and `get_category_list()` to see YouTube’s
regions and content categories.

``` r
head(get_region_list(key))
#>   regionId     region
#> 1       DZ    Algeria
#> 2       AR  Argentina
#> 3       AU  Australia
#> 4       AT    Austria
#> 5       AZ Azerbaijan
#> 6       BH    Bahrain
head(get_category_list(key, region = "Sweden"))
#>   categoryId         category
#> 1          1 Film & Animation
#> 2          2 Autos & Vehicles
#> 3         10            Music
#> 4         15   Pets & Animals
#> 5         17           Sports
#> 6         18     Short Movies
```

Use the function `graph_top_videos_category()` to see the overall top
trending videos broken down by content category.

``` r
graph_top_videos_category(key, n = 25)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
graph_top_videos_category(key, region = "United Kingdom", n = 25)
```

<img src="man/figures/README-unnamed-chunk-8-2.png" width="100%" />

The `comment_cloud` function also needs a Youtube video ID. To find the
Id of a youtube video look at the url and find the last part after the
**v=**

For example in `https://www.youtube.com/watch?v=QjA5faZF1A8` the Id
would be `QjA5faZF1A8`
