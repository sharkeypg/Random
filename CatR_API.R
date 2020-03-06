#connect to cat API and post pictures on Twitter account

#libraries
library(httr)
library(jsonlite)
library(stringr)
library(rtweet)
library(lubridate)

date_today <- Sys.Date()

## authenticate via web browser
token <- create_token(
  app = "Cat Poster",
  consumer_key = Sys.getenv("TWITTER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_API_SECRET_KEY"),
  access_token = Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("TWITTER_ACCESS_SECRET_TOKEN")
)

#only way to handle annoying proxy variables
Sys.setenv(https_proxy = str_replace(Sys.getenv('https_proxy'),'https','http'))

#components of the request URL (cat)
cat_path <- "https://api.thecatapi.com/v1/images/search"

#components of the request URL (dog)
dog_path <- 'https://dog.ceo/api/breeds/image/random'

#strip url of image from search URL - alternate between dog and cat

if(yday(date_today) %% 2) {
  
  r <- GET(url = cat_path, add_headers('x-api-key' = Sys.getenv("CAT_KEY")))
  r <- content(r,as='text',encoding='UTF-8')
  
  url_pattern <- "http[s]?://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  r <- str_extract(r,url_pattern)
  msg <- "Enjoy today's #rcat tweeted from #rstats."
  
} else{
  
  r <- GET(url = dog_path)
  r <- content(r)$message
  
  msg <- "Enjoy today's #rdoggo tweeted from #rstats."
  
}

#download file
path <- paste0('~/Documents/Training/Self/Cat pictures/cat_',Sys.Date(),".jpg")
file <- download.file(r, path)

#post tweet
post_tweet(
  status = paste0(msg),
  media = path,
  token = NULL,
  in_reply_to_status_id = NULL,
  destroy_id = NULL,
  retweet_id = NULL,
  auto_populate_reply_metadata = FALSE
)
