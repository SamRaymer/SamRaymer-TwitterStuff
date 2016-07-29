
# SamRaymer::TwitterStuff

Returns recent tweets and common friends!

## API Doc
### Recent statuses
`/statuses/recent/{screen_name}`
* Returns up to 30 tweets from a given user's timeline (configurable on server via `recent_tweet_count` in `config.yml`)
* Tweets are returned as an array of Twitter "status" JSON objects (see https://dev.twitter.com/overview/api/tweets )

### Common follows
`/common-follows?name1={screen_name}&name2={different_name}`
* Returns the intersection of followed users, given the `name1` and `name2` parameters above.
* Users are returned

### Sample response json
(large amounts of tweet json replaced with ellipses by author):
```
{ 
    status: 200,
    data: [ 
        { id: 1, text: 'data'...}, 
        { id: 2, text: 'goes'...}, 
        { id: 3, text: 'gere'...} 
    ] 
}
```


## Installation

* Unzip the project into your folder
* Ensure you have a version of perl >= 5.20
* Set the following environment variables using your API keys from https://apps.twitter.com/
    * TWITTER_CONSUMER_KEY
    * TWITTER_CONSUMER_SECRET
    * TWITTER_TOKEN
    * TWITTER_TOKEN_SECRET
* **If running locally** and not in Heroku, 
    * Make sure that you have all necessary packages installed by navigating to the dir and running `cpanminus . --installdeps` 
        * cpanm installation instructions available at http://cpanmin.us
        * To speed things up, you can add `--notest` to the end of the command
        * Don't forget to add a `sudo` to the beginning if your perl environment needs one
    * Run `plackup bin/app.pgsi` to start
* **If running on heroku** the Procfile should automatically ensure all packages are installed and start the service.
    * Make sure the environment variables above have been set using heroku config vars https://devcenter.heroku.com/articles/config-vars
