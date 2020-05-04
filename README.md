
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

Use the function `get_top_videos()` to create a data frame of the
current top trending videos on YouTube. You can specify which region and
content category you are interested in.

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

## Word Cloud from Youtube Comments

use the `make_cloud()` function to create a word cloud of all the
comments for a particular video.

In addition to the API key, `make_cloud()` also needs a Youtube video
ID. To find the Id of a youtube video look at the url and find the last
part after the **v=**

For example in `https://www.youtube.com/watch?v=QjA5faZF1A8` the Id
would be `QjA5faZF1A8`

``` r
video_id = "QjA5faZF1A8"
make_cloud(key, video_id)
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />

## Sentiment analysis of YouTube Titles

Use `get_top_titles()` to returns a list of 200 titles from the most
popular YouTube video pages using your API key.

``` r
head(get_top_titles(api_key))
#> [1] "Dixie D'Amelio's Wisdom Teeth Adventure"                                     
#> [2] "Rod Wave - Girl Of My Dreams (Official Music Video)"                         
#> [3] "We Tricked Carole Baskin into Giving Us Her First Interview Since Tiger King"
#> [4] "WHATS INSIDE MY ORGANIZED PANTRY!"                                           
#> [5] "Rick and Morty x Wendy’s [ad]"                                               
#> [6] "Charli's Birthday Shoutout Reaction"
```

Use `titles_sentiment_type_nrc()` to generates a plot of the number of
words that contribute to different sentiments in the top 200 YouTube
titles using the NRC lexicon.

``` r
titles_sentiment_type_nrc(api_key)
#> Joining, by = "word"
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

Additionally, you can use `titles_sentiment_contribution_bing()` to
generate a plot of the top 10 words that contribute to positive and
negative sentiment in the top 200 YouTube titles using the Bing lexicon.

``` r
titles_sentiment_contribution_bing(api_key)
#> Joining, by = "word"
#> Selecting by n
```

<img src="man/figures/README-unnamed-chunk-14-1.png" width="100%" />

## Word Cloud from YouTube Titles

Use `make_top_title_word_cloud()` to make a word cloud of 200 of the
titles on YouTube’s most popular videos. In addition to an API key, this
function allows you to input custom parameters for the size, color and
shape of the title word cloud. For more infomration on size, color and
shape parameter options
[Wordcloud2](https://cran.r-project.org/web/packages/wordcloud2/vignettes/wordcloud.html).

``` r
make_top_title_word_cloud(api_key, size =1, color="random-light", shape = "circle")
#> PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.
```

<!--html_preserve-->

<div id="htmlwidget-9d8a86620e5c1c43d1ce" class="wordcloud2 html-widget" style="width:100%;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-9d8a86620e5c1c43d1ce">{"x":{"word":["1","10","100","11","12th","14","1966","1993","1on1","1st","2","200428","2020","2020.05.01","24","25","250,000","27","3","31","34","4","4000","45","4wd","5,000","50","501kg","53","5th","66","7","8","9","90th","aaron","abc","access","accidentally","actor","actual","ad","added","adventure","aerial","age","air","airplane","alex","alfa","alignment","allen","alone","america","andrew","andy","angel","animado","animated","animation","anime","annual","ap","apart","apex","arjona","art","artists","ashley","assassin's","assassin’s","astro","astronomical","atlanta's","audio","austin","awards","back","backyard","bad","bahamas","baker","baldwin","bali","balvin","banda","bang","bank","baskin","batmobile","battle","battlefront","becoming","beginners","begun","behind","bein","bella","benedict","bengals","bestfriend","better","beverly","beyonce","bf","bgt","bhabie","bhad","big","bilgewater","binky","birthday","bjornsson","black","blackened","block","body","boom","borders","boss","bosslogic","bounce","bowl","boyce","boyfriend","brain","breakdown","breaking","breathe","brian","briefing","broadcast","brock","buffs","built","bulls","buns","buzzer","cab","cabello","cameron","camila","can","candles","cant","car","care","carole","carti","cat","celebration","cent","cgi","challenge","chamber","chance","channel","chapter","character","charli's","charts","check","checker","chicken","chief","chloe","choppa","christian's","christmas","chung","cinnamons","city","class","click","clickbait","clone","clones","coffee","coils","college","colourfulmula","combs","comics","commercial","community","concept","confirms","confronts","coronavirus","correct","cost","country","coyote","crap","crash","cravings","creates","creator","creature","creed","crew","cross","crunchy","cry","cumberbatch","cuomo","custom","d","d'amelio's","dad","daddy","dalgona","dalton","dance","daps","dark","daughter","day","de","dead","deadlift","death","deep","demo","demonstration","designer","devon","dexta","dies","diet","disaster","discovered","distancing","dixie","diy","dj","doctors","documentary","dog","dogg","dogs","doja","doll","donna","double","doubtful","drag","dragon","drake","drama","drea","dream","dreams","drive","dubu","duck","dumbledore’s","durk","e","earth","easter","eating","eazy","edible","edition","eggs","el","eleven","elizabeth","elnaz","em","ending","enforces","ep","episode","episodes","error","escape","eternity","event","every","everyday","everything","exam","exams","experiments","experts","exposed","express","extra","extralicks","f","fact","facts","fadaei","fails","family","far","farruko","favorite","fbg","feat","federal","feet","fertility","fight","final","finger","first","flight","follow","food","footage","force","ford","fortnite","four","fox","frankenstein","fredo","free","freestyle","friends","frog","fruit","ft","full","fundraiser","funniest","future","g","gabi","gad","gallon","game","gaming","ganjeong","gates","gave","get","gigi","girl","giving","gloves","goes","golden","golrokh","gomez","gone","goonies","gordon","gorillaz","got","gouache","governor","gq","grandson","great","green","greg","gt","guapdad","guide","guy","ha","habitable","hacks","hadid","hafthor","hair","haircut","hall","halsey","hamid","hand","happened","happy","harlow","harry","hate","hay","hazbin","hbo","head","headed","hello","helluva","herbo","high","highlights","history","hit","hold","holds","hole","home","honey","hongos","hoonicorn","hopsin","horn","hornets","hotel","hour","hours","huff","ice","ideal","identical","impossible","influencer","ink","inside","instagram","instant","internet","interview","irrfan","it’s","j","jack","jackboy","jalen","jam","jd","jealous","jenner","jerry","jewels","jhope","john","jong","josh","journey","jp","julia","just","justin","keef","kehlani","ken","kevin","khalid","khalifa","khan","killer","kim","kind","king","kitsilano","knight","knock","korat","korea’s","kourtney","kry","kuwtk","kylie","la","lab","landscape","lane","lanez","later","laugh","launch","layers","leader","legacy","legends","licks","life","light","liking","lil","lin","list","lite","live","living","lockdown","loops","lovecraft","low","luke","lyric","m","m.a","mac","macdonald","made","majority","makeover","makeup","making","maldición","malo","man","manuel","marshmello","masicka","mask","massive","matteo","mavic","may","mcafee","mcdonald's","mcnuggets","mediadel","medusa","megan","metallica","mexico","michaels","milk","miller","million","minaj","mind","mini","minnie","minutes","miranda","mislead","mo3","moana","mold","mom","moment","monarchy","month","moon","morning","morty","mother","move","ms","mu","mumbai","murder","music","mustang","mv","na","nail","nails","national","natural","navy","nbc","nct","new","news","nice","nick","nicki","nicky","nightly","niki","nle","north","now","nyt","obligatory","offerman","official","oficial","oh","olé","one","ooh","opportunity","order","orders","organized","origin","outlands","overpowered","package","pad","pain","painting","pam","panda","pantoja","pantry","paper","paradise","park","parks","part","parties","pat","pawzam","pc","pepper’s","performance","phenomena","piano","plan","plans","play","playboi","pockets","posting","potter","pranks","preachy","pregnancy","premier","premiere","present","president","problem","productivity","project","prom","properly","proposals","proposes","q","quadeca","quarantine","que","qué","quiles","r","raid","rainbow","ranger","react","reaction","reacts","realize","recap","receiver","record","recreating","recreation","redcorn","releases","releasing","relieving","remix","repair","reserve","results","returning","reunited","reveal","revenge","review","ricardo","ricch","rich","rick","ridin","rise","rivera","rnid","robertson","rock","rod","roddy","rolling","ron","rosa","ross","row","rule","run","runeterra","rural","rust","s","sadie","said","sale","sammy","savage","saxe","say","scarif","scary","scenes","scissors","scott","scratch","scrubs","sea","search","season","second","secret","secrets","see","seize","selena","shares","shell","short","shorty","shot","shoutout","shoved","side","sidemen","since","singing","sir","siren","sister’s","six","skepta","sketch","skywalker","sleep","snails","snatched","snoop","soap","sober","social","sondheim","song","spaceship","special","spotted","spring","stage","stallion","star","stay","stayhome","steel","stereotypes","still","stimulus","stones","stories","story","strategy","stream","street","streetz","stress","struggles","students","style","subframe","subscribe","success","summer","support","surfing","surprising","swanson's","swap","sweet","taeyeon","tag","take","taking","tales","tapes","team","teaser","technology","teeth","tell","testing","texas","thai","theatre","thee","theory","thief","things","thinks","thor","thorne","throw","thru","tier","tiger","tik","tiktok","time","timelapse","times","ting","tofu","together","tok","toks","tom","tonight","tony","top","tory","tour","tournament","town","tp","track","tractor","trailer","transformation","transformed","trap","travis","tricked","tricks","tried","tries","truck","true","trump","try","trying","turbocharged","tutorial","twice","twin","txt","u.s","ubisoft","ugly","un","uncertain","understand","unidentified","update","upload","us","v","valhalla","valley","van","ver","version","vfx","video","videos","villains","viral","visual","vlog","von","vs","w","walk","walker","walkthrough","want","wars","watching","water","wave","wayne","wedding","weirdly","wendy’s","whats","wind","wisdom","withme","without","wiz","woosah","work","world","wrong","wuhan","x","yankee","years","yg","york","young","youtube","yt","zones","zoom","걸음","꿈을","널","더","두부강정","드림","라이트","시즈","아스트로","엔시티","우리들의","찾아가","첫","청하","태연","투모로우바이투게더","향한"],"freq":[6,2,2,1,1,1,1,1,1,1,5,1,7,1,2,1,1,1,1,1,1,4,1,1,1,1,1,3,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,2,1,1,1,1,1,1,2,2,1,1,2,1,1,1,1,1,1,1,4,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,5,1,1,1,5,1,1,1,1,1,1,1,2,1,1,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,4,1,1,2,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,4,1,1,1,1,1,3,1,1,1,1,2,1,3,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,2,1,1,4,1,1,2,1,2,1,3,1,1,5,1,1,1,1,1,1,1,1,1,1,2,1,3,1,1,1,1,1,1,1,1,3,4,1,1,2,1,2,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,6,1,1,2,1,1,1,1,1,1,1,1,1,1,2,1,1,7,6,1,1,1,3,1,1,1,3,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,2,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,2,1,2,1,1,1,1,2,1,1,1,1,1,1,1,2,1,1,1,1,1,1,2,1,2,1,1,1,1,1,3,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,2,1,1,1,1,2,2,1,1,1,1,2,1,1,1,1,3,1,1,1,7,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,2,1,1,2,1,2,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,1,2,1,4,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,12,2,3,1,1,1,1,1,1,3,4,5,5,1,1,4,1,2,1,2,1,1,1,1,1,31,1,1,3,3,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,3,3,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,1,8,1,1,1,1,1,1,1,1,5,1,1,1,1,1,1,3,1,1,1,1,4,1,1,1,2,1,1,1,2,1,1,1,1,4,1,1,1,1,2,1,1,1,1,1,1,1,1,2,2,1,1,1,2,1,1,1,1,1,4,1,2,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,6,1,1,1,1,2,1,1,1,1,1,2,1,2,2,1,2,1,1,1,1,1,2,1,1,1,1,2,1,1,1,1,1,1,1,3,2,1,1,1,3,1,1,2,2,1,1,1,1,1,1,3,1,1,1,1,1,1,1,4,1,5,1,1,1,1,3,2,2,1,1,1,1,1,1,1,2,1,1,1,2,2,1,1,1,1,1,1,1,1,2,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,1,2,1,1,1,1,1,34,1,1,2,1,1,1,2,1,1,1,1,1,3,1,1,1,1,2,1,1,1,1,1,2,2,1,1,3,3,2,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,1,1],"fontFamily":"Segoe UI","fontWeight":"bold","color":"random-light","minSize":0,"weightFactor":5.29411764705882,"backgroundColor":"white","gridSize":0,"minRotation":-0.785398163397448,"maxRotation":0.785398163397448,"shuffle":true,"rotateRatio":0.4,"shape":"circle","ellipticity":0.65,"figBase64":null,"hover":null},"evals":[],"jsHooks":{"render":[{"code":"function(el,x){\n                        console.log(123);\n                        if(!iii){\n                          window.location.reload();\n                          iii = False;\n\n                        }\n  }","data":null}]}}</script>

<!--/html_preserve-->
