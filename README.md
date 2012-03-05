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

    % ruby -Ku bin/stream_store_mongo.rb
