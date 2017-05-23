# LogErrorHandler

log_error_handler - it’s a gem for revealing  and processing bugs  in your server. Currently there are 3 variants of actions for bug revealing such as.: type in terminal, to write down in a separate document or send http request to the website. We’ll discuss about them in details a bit later.
![image](https://cloud.githubusercontent.com/assets/20104771/26356962/84f12f4c-3fd6-11e7-925b-9cb3502d80dc.png)
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'log_error_handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install log_error_handler

## Usage

To make gem work , there should be  a constant output data flow. You can do this in two ways:
1. To lead pipe to gem, e.g

        $ rails s | log_error_handler
    
    This will ensure   stdout  of your program to stdin of gem. The minus of such an approach is that you can apply it only while launching your program which logs you want to track.  
  
2. To show the way to your log file to program,e.g:

        $ log_error_handler -l log/development.log
        
To output logs  in a correct way gem needs a unique identification of each request to server .In case the majority of servers are multithreaded and each new request is elaborated in a new flow , so the best suit for this will be thread identificator (tid). To add this unique identifier, e.g in Ruby on Rails framework you need to add only one line: 
```ruby
config.log_tags = [:object_id]
```
After this in each line of output logs  tid is output. It looks like this: 
![image](https://cloud.githubusercontent.com/assets/20104771/26357965/a7c68aa0-3fd9-11e7-9249-dc0c6a0b6494.png)

To find tid gem uses regexp 
```ruby
/^\[\d+\]/ 
```
But if the tid output way differs you can set it:

![image](https://cloud.githubusercontent.com/assets/20104771/26358050/fc8febee-3fd9-11e7-8aec-67c1e0e9e6e7.png)

For example if  tid  is located in curly brackets and not at the start of the line: 

        $ log_error_handler -t /\\{\\d+\\}/
In case this  regexp is written in terminal, we need double screen version.

Gem finds out that the request has an error when finds the line which corresponds to regexp of the error:
![image](https://cloud.githubusercontent.com/assets/20104771/26358136/3cdeeda8-3fda-11e7-9a03-c6692653aa3c.png)

For example we need to catch not only  error 500, but also 404:

        $ log_error_handler -e "/(500)|(404).*error/i"

To look through values by default you need to type:
![image](https://cloud.githubusercontent.com/assets/20104771/26358252/999fb3b0-3fda-11e7-886e-d5674a5fe103.png)
Time in settings by default  is given in seconds.

Option `--not_modify_timeout`  means time for  thread to finish writing logs in this file, if timeout expires, and during this time file will not be changed at least once, so the file is sent to output, and if there are some errors it will be deleted.

Option `--log_file_tracker_waiting` means how often the checking cycle  of temporary files in each thread will take place

Option `--debug_mode` provides the data output in stdout about reading from stdin.

As it was mentioned above there are 3 ways of  data input:
1. In stdout is performed by default, if none of the output parameters was indicated
2. In the file if a parameter was indicated

    ![image](https://cloud.githubusercontent.com/assets/20104771/26358415/2dfd67f0-3fdb-11e7-930e-ac6a80888e9e.png)
    
    For example:
    
        $ log_error_handler -f error.log
3. Into the network. For this you need to indicate a parameter:
    ![image](https://cloud.githubusercontent.com/assets/20104771/26358483/621b0eac-3fdb-11e7-870d-f3739a847842.png)
    
    For example: 
    
            $ log_error_handler -u https://app.geteasyqa.com/projects/upload_crashes
    http method post is used by default for  data sending, but it can be easily replaced
    ![image](https://cloud.githubusercontent.com/assets/20104771/26358600/aece1ce4-3fdb-11e7-85d9-d6d399a153fc.png)
    
    For example:
       
            $ log_error_handler -u https://app.geteasyqa.com/projects/upload_crashes -m put
    Message is a  key by default, under which error is located , so parameter is responsible for this value 
    ![image](https://cloud.githubusercontent.com/assets/20104771/26358654/dc1950d8-3fdb-11e7-8669-dc3def2520bf.png)
    
    For example: 
           
            $ log_error_handler -u https://app.geteasyqa.com/projects/upload_crashes -m put -k error
    If you need to send some additional parameters with an error so you can set them by means of options such as:
    ![image](https://cloud.githubusercontent.com/assets/20104771/26358699/000362cc-3fdc-11e7-9ae7-1b84dc75ebc6.png)
    
    Or:
    
    ![image](https://cloud.githubusercontent.com/assets/20104771/26359053/1b09d1ae-3fdd-11e7-97be-10a66558e387.png)
    
    For example:
                       
            $ log_error_handler -u https://app.geteasyqa.com/projects/upload_crashes -m put -k error -a "{\"token\":\"uQF7ZYtHh9VDMXBaJojq\"}"
Before sending all errors are encoded in Base64
            
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/thinkmobiles/log_error_handler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

