require 'date'
require 'time'
require 'uri'

require_relative './search_googlehome'

class Jiho

    @@last = nil
    @@SEND_CMD = File.expand_path("../send_googlehome.rb", __FILE__)

    def self.tick list=[], lang='ja'
        now = Time.now.strftime("%H:%M")
        yobi = %w(日 月 火 水 木 金 土)[Date.today.wday]
        return if @@last == now

        list.select{|item|
            item["at"] == now
        }.select{|item|
            item["yobi"].include?(yobi)
        }.each{|item|
            device, content = item["device"], item["content"]
            url = (content =~ /^https?:/) ? content : "https://translate.google.com/translate_tts?ie=UTF-8&tl=#{lang}&client=tw-ob&q=#{URI.escape(content)}"
            talk(device, url)
        }
        @@last = now
    end
    def self.talk name, url
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
                `ruby #{@@SEND_CMD} --address="#{host}" --port="#{port}" --url="#{url}" &`
            end
        }
    end

end

