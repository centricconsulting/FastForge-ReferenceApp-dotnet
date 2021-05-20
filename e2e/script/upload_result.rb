require 'net/http/post/multipart'
require 'pry'
require 'trollop'

puts 'Cucumber test result uploader'

opts = Trollop::options do
  opt :suite, 'Name of the suite to upload', type: :string        # string --name <s>, default nil
  opt :env, 'Name of the env the suite was run in', type: :string
  opt :file, 'Name of the file containing results', type: :string
  opt :runtime, 'Name of the file containing results', type: :string
end
Trollop::die :file, 'must be specified' unless opts[:file]
Trollop::die :env, 'must be specified' unless opts[:env]
Trollop::die :suite, 'must be specified' unless opts[:suite]
Trollop::die :file, 'must exist' unless File.exist?(opts[:file]) if opts[:file]

p opts # a hash: { :monkey=>false, :name=>nil, :num_limbs=>4, :help=>false }

filename = 'sanity_check.json'
runname = 'donavan test'
env = 'N/A'

url = URI.parse('http://localhost:3000/raw_results')
req = Net::HTTP::Post::Multipart.new url.path,
                                     'raw_result[filedata]' => UploadIO.new(File.new(opts[:file]), 'application/octet-stream', File.basename(opts[:file])),
                                     'raw_result[runname]' => opts[:suite],
                                     'raw_result[test_environment]' => opts[:env],
                                     'raw_result[runtime]' => opts[:runtime]
Trollop::die :suite, 'must be specified' unless opts[:suite]

puts 'Uploading results'
begin
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end
rescue Exception => ex
  puts "Upload failed #{ex.message}"
end

puts 'All Done'
