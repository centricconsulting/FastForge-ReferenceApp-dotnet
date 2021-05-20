require 'twilio-ruby'
require 'pry'

module RakeHelper
  def self.merge_json_files(dir, outfile)
    files = Dir.glob("#{dir}/*.json")
    File.open(outfile, 'wb') { |f| f.write(JSON.dump(files.flat_map { |ff| JSON.parse(File.read(ff)) })) }
  end

  def self.notify_complete

    account_sid = 'AC928786569e1941b4ae54864c521019d5'
    auth_token = '8cf6385720d8da9dbdd4b12f76d5ea79'

    @client = Twilio::REST::Client.new account_sid, auth_token
    @client.messages.create( from: '+16147052559', to: '+16146682306', body: "Your test run is complete")
  end
end