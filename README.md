# Kippt

Kippt is a gem that provides a client library for using [Kippt.com API](https://kippt.com/developers/).

[![Build Status](https://secure.travis-ci.org/vesan/kippt.png)](http://travis-ci.org/vesan/kippt)


## Installation

Add this line to your application's Gemfile:

```ruby
gem "kippt"
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install kippt
```


## Usage


### Authentication

To be able to use the API you need to authenticated. There's two ways to authenticate:


#### With login credentials

```ruby
client = Kippt::Client.new(username: "vesan", password: "s3cr3t")
# Methods called on `client` will use the passed credentials
```


#### With token

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
# Methods called on `client` will use the passed credentials
```


### Account

You can get the account details (username and token):

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
account = client.account
account.username #=> "vesan"
account.token    #=> "2544d6bfddf5893ec8617"
```

Always use token instead of the password if possible because it's more secure.


### Resources


#### Lists

Get all the lists:

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
lists = client.lists.all # Returns Kippt::ListCollection
```

Get single list:

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
list_id = 10
list = client.lists[list_id] # Returns Kippt::ListItem
```


#### Clips

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
clips = client.clips.all # Returns Kippt::ClipCollection
```

Both ListCollection and ClipCollection are Enumerable.


### Pagination

Lists and clips are paginated:

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
clips = client.clips.all

clips.total_count
clips.offset
clips.limit
```

You can get next and previous set of results:

```ruby
clips.next_page? #=> true
clips.next_page # Returns new Kippt::ClipCollection
clips.previous_page? #=> true
clips.previous_page # Returns new Kippt::ClipCollection
```

Limit and offset can be controlled manually:

```ruby
client.clips.all(limit: 25, offset: 50)
```


### Search

Clips can be searched:

```ruby
client.clips.search("kippt") #=> Returns Kippt::ClipCollection
```

Other available options are `is\_starred: true` and `list: [list-id]` like:

```ruby
client.clips.search(q: "kippt", list: 5, is_starred: true)
```


### Creating and updating resources

You can create new resources, here for example clips:

```ruby
clip = client.clips.build
clip.url = "http://github.com"
clip.save #=> Returns boolean
```

If you are missing required fields `#save` will return `false` and you can use 
`#errors` to get the error messages returned by the API.

```ruby
clip = client.clips.build
clip.save   #=> false
clip.errors #=> ["No url."]
```

### Deleting resources

Deleting resources is done with `#destroy`:

```ruby
clip_id = 1001
clip = client.clips[clip_id]
clip.destroy #=> true
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Do your changes
4. Run the tests (`rspec spec`)
5. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request (`https://github.com/vesan/kippt/pulls`)
