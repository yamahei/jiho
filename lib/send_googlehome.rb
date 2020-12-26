require 'date'
require 'time'
require 'uri'
require 'eventmachine'

require_relative './castv2'

class SendGoogleHome

    def self.send(ip_addr, port, url)

        EventMachine.run {

        Castv2::Client.launch(ip_addr, port) do |client|

                platform = Castv2::Platform.new(client)
                EM.add_timer(60){
                    platform.stop{ EM.stop }
                } 

                platform.connect do
                    platform.launch(Castv2::DefaultMediaReceiver) do |media|
                        media_data = {
                            contentId: url,
                            contentType: 'audio/mp3',
                            streamType: 'BUFFERED', # or LIVE
                        }
                        media_options = {autoplay: true}
                        media.load(media_data, media_options) {
                            media.play { EM.stop }
                        }
                    end
                end
            end
        }
    end

end



if __FILE__ == $0 then
    require "optparse"

    @address = nil
    @port = nil
    @url = nil
    @usage = nil
    OptionParser.new do |opt|
      opt.on('-a', '--address address', "ip address of google home") { |o| @address = o }
      opt.on('-p', '--port port', "port of google home") { |o| @port = o }
      opt.on('-u', '--url url', "Audio URL") { |o| @url = o }
      opt.on("-h", "--help", "Prints this help") { puts opt; exit }
      @usage = opt.to_s
    end.parse!
    
    if !@address || !@port || !@url then
      puts @usage; exit
    end
    SendGoogleHome.send(@address, @port, @url)
end
