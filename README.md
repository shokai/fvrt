fvrt
====

Install Dependencies
--------------------

    % gem install bundler
    % bundle install


Config
------

    % cp sample.config.yaml config.yaml

edit it.


Auth
----

    % ruby bin/auth.rb

put access_token and access_secret into config.yaml


Store Tweets
------------

    % ruby -Ku bin/stream_store_mongo.rb --help
    % ruby -Ku bin/stream_store_mongo.rb --verbose


Check ReTweets

    % ruby -Ku bin/check_rb.rb --help
    % ruby -Ku bin/check_rb.rb --loop -i 5


Console
-------

    % bin/console


Twitter API Console
-------------------

    % bin/twitter_api_console
    > Twitter.rate_limit_status


Check API Hourly limit
----------------------

    % bin/api_limit
