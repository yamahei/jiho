require 'date'
require 'time'
require 'uri'

require_relative './search_googlehome'

class Jiho

    @@last = nil
    @@SEND_CMD = File.expand_path("../send_googlehome.rb", __FILE__)
    @@VOICERSS_APIKEY = ENV['VOICERSS_APIKEY']

    def self.tick list=[], lang='ja-jp'
        puts "Jiho.ticl[list.length=#{list.length}, lang=#{lang}, @@last=#{@@last}]"
        now = Time.now.strftime("%H:%M")
        yobi = %w(日 月 火 水 木 金 土)[Date.today.wday]
        return if @@last == now

        list.select{|item|
            item["at"] == now
        }.select{|item|
            item["yobi"].include?(yobi)
        }.each{|item|
            device, content = item["device"], item["content"]
            begin
                Thread.new(device, content) {|_device, _content|
                    Thread.pass
                    talk(_device, _content)
                }
            rescue => e
                puts e.full_messages
            end
        }
        @@last = now
    end
    def self.talk name, content, lang='ja-jp'
        url = (content =~ /^https?:/) ? content : "http://api.voicerss.org/?key=#{@@VOICERSS_APIKEY}&hl=#{lang}&src=#{URI.escape(content)}"
        puts "Jiho.talk[name=#{name}, content=#{content}]"
        puts "(url=#{url})" if url != content
        _devices = SearchGoogleHome.scan
        devices = _devices.map{|_device|
            {
                name: _device["fn"],
                host: _device["address"],
                port: _device["port"],
            }
        }
        devices.each{|device|
            if !name || name.empty? || name == device[:name] then
                host = device[:host]
                port = device[:port]
                puts "Jiho.talk - send[name=#{name}, host=#{host}, port=#{port}]"
                `ruby #{@@SEND_CMD} --address="#{host}" --port="#{port}" --url="#{url}" &`
            end
        }
    end

end

