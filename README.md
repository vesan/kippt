# Kippt

Kippt is a gem that provides a client library for using Kippt.com API.

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

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
account = client.account
account.username #=> "vesan"
account.token    #=> "2544d6bfddf5893ec8617"
```

### Resources

Currently this client library is read-only! Ability to create and edit
resources will be added soon.

#### Lists

Get all the lists:

```ruby
client = Kippt::Client.new(username: "vesan", token: "2544d6bfddf5893ec8617")
lists = client.lists # Returns Kippt::ListCollection
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
clips = client.clips # Returns Kippt::ClipCollection
```

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
clips.prev_page? #=> true
clips.prev_page # Returns new Kippt::ClipCollection
```

There's also `#previous\_page?` and `#previous\_page`.

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

### Creating, updating and deleting resources

**NOT IMPLEMENTED YET**

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

* Ability to create, update and delete resources
* Add user agent string
